import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:meta/meta.dart';
import 'package:vpn/configurations/conf.dart';
import 'package:vpn/configurations/validators.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/data/repo/data_vpn_repo.dart';
import 'package:vpn/data/repo/recive_configs_repo.dart';

part 'config_list_event.dart';
part 'config_list_state.dart';

class ConfigListBloc extends Bloc<ConfigListEvent, ConfigListState> {
  final IDataVpnRepo dataVpnRepo;
  final IReciveConfigsRepo reciveConfigsRepo;

  FlutterV2ray? _flutterV2ray;

  ConfigListBloc({required this.dataVpnRepo, required this.reciveConfigsRepo})
    : super(ConfigListInitial()) {
    on<ConfigListEvent>((event, emit) async {
      if (event is StartCheckingStatusEvent) {
        final countConfigs = await dataVpnRepo.getAllVpns();
        if (countConfigs.isEmpty) {
          emit(EmptyConfigState());
        }
      }
      if (event is StartRecivingConfigsEvent) {
        try {
          emit(StartRecivingConfigsState());
          final response = await reciveConfigsRepo.futureConfigs(
            'v2ray_configs.txt',
          );

          if (response.isEmpty) {
            emit(RecivingConfigsErrorState(error: "No Configs Found"));
          } else {
            separatingconfigs(response);
          }
        } catch (e) {
          emit(RecivingConfigsErrorState(error: e.toString()));
        }
      }

      // ===== بازنویسی کامل با رویکرد ترتیبی (Sequential) و قابل اعتماد =====
      if (event is StartTestingPingsForAllConfigsEvent) {
        final List<ConfigModel> allConfigs = List.from(event.configs);
        final List<ConfigModel> testedConfigs = [];
        List<ConfigModel> notTestedConfigs = List.from(allConfigs);

        // State اولیه که نشان می‌دهد تست شروع شده
        emit(
          StartingTestPingConfingsState(
            configsNotTested: notTestedConfigs,
            configsTested: testedConfigs,
          ),
        );

        // اطمینان از مقداردهی اولیه V2ray (فقط یک بار)
        if (_flutterV2ray == null) {
          _flutterV2ray = FlutterV2ray(
            onStatusChanged: (status) {
              debugPrint("V2Ray Status Changed: ${status.state}");
            },
          );
          try {
            await _flutterV2ray!.initializeV2Ray();
          } catch (e) {
            emit(
              RecivingConfigsErrorState(
                error: "V2Ray initialization failed: $e",
              ),
            );
            return;
          }
        }

        // حلقه for ساده برای اجرای ترتیبی و قابل اطمینان تست‌ها
        for (final configModel in allConfigs) {
          int currentPing = -1; // مقدار پیش‌فرض برای خطا

          try {
            final parser = _tryParse(configModel.config);
            if (parser == null) {
              currentPing = -2; // کانفیگ نامعتبر
            } else {
              final ping = await _flutterV2ray!
                  .getServerDelay(config: parser.getFullConfiguration())
                  .timeout(const Duration(seconds: 5));

              currentPing = ping > 0 ? ping : -1;
            }
          } catch (e) {
            debugPrint(
              "Ping Error for ${configModel.config.substring(0, 20)}...: $e",
            );
            currentPing = -1; // خطا در پینگ
          }

          // پس از گرفتن پینگ، لیست‌ها را آپدیت می‌کنیم
          testedConfigs.add(
            ConfigModel(config: configModel.config, delay: currentPing),
          );
          notTestedConfigs.removeWhere(
            (item) => item.config == configModel.config,
          );

          // یک State جدید با لیست‌های به‌روز شده به UI می‌فرستیم
          emit(
            StartingTestPingConfingsState(
              configsNotTested: List.from(notTestedConfigs),
              configsTested: List.from(testedConfigs),
            ),
          );
        }

        // پس از اتمام تمام تست‌ها، نتایج نهایی را مرتب کرده و emit می‌کنیم
        testedConfigs.sort((a, b) {
          if (a.delay > 0 && b.delay <= 0) return -1;
          if (b.delay > 0 && a.delay <= 0) return 1;
          if (a.delay == -2 && b.delay == -1) return 1;
          if (a.delay == -1 && b.delay == -2) return -1;
          return a.delay.compareTo(b.delay);
        });

        emit(TestPingConfingsSuccessState(configsTested: testedConfigs));
      }
    });
  }

  // متد کمکی برای گرفتن پینگ یک کانفیگ (برای تمیزتر شدن کد)
  Future<ConfigModel> _getSinglePing(ConfigModel configModel) async {
    try {
      final parser = _tryParse(configModel.config);
      if (parser == null) {
        return ConfigModel(config: configModel.config, delay: -2); // نامعتبر
      }

      // از نمونه‌ی V2ray که در کلاس ذخیره شده استفاده می‌کنیم
      final ping = await _flutterV2ray!
          .getServerDelay(config: parser.getFullConfiguration())
          .timeout(
            const Duration(seconds: 7),
          ); // افزایش تایم‌اوت برای شبکه‌های کندتر

      return ConfigModel(
        config: configModel.config,
        delay: ping > 0 ? ping : -1, // اگر پینگ 0 بود خطا در نظر بگیر
      );
    } catch (e) {
      debugPrint(
        "Ping Error for ${configModel.config.substring(0, 20)}...: $e",
      );
      return ConfigModel(config: configModel.config, delay: -1); // خطا
    }
  }

  void separatingconfigs(List<String> configs) {
    // ... این متد بدون تغییر باقی می‌ماند ...
    List<String> vless = [];
    List<String> vmess = [];
    List<String> trojan = [];
    List<String> shadowSocks = [];
    List<String> tuic = [];
    List<String> unknownProtocol = [];

    for (var config in configs) {
      final protocol = Validators.getProtocolType(config);
      switch (protocol) {
        case 'VLESS':
          vless.add(config);
          break;
        case 'VMess':
          vmess.add(config);
          break;
        case 'Trojan':
          trojan.add(config);
          break;
        case 'ShadowSocks':
          shadowSocks.add(config);
          break;
        case 'Tuic':
          tuic.add(config);
          break;
        default:
          unknownProtocol.add(config);
          break;
      }
    }

    emit(
      RecivingConfigsSuccessState(
        vless: vless,
        vmess: vmess,
        trojan: trojan,
        shadowSocks: shadowSocks,
        tuic: tuic,
        unknownProtocol: unknownProtocol,
      ),
    );
  }

  V2RayURL? _tryParse(String url) {
    try {
      return FlutterV2ray.parseFromURL(url);
    } catch (e) {
      return null;
    }
  }
}
