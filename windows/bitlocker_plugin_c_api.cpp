#include "include/bitlocker/bitlocker_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "bitlocker_plugin.h"

void BitlockerPluginCApiRegisterWithRegistrar(
        FlutterDesktopPluginRegistrarRef registrar) {
    bitlocker::BitlockerPlugin::RegisterWithRegistrar(
            flutter::PluginRegistrarManager::GetInstance()
                    ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
