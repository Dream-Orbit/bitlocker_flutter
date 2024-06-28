#ifndef FLUTTER_PLUGIN_BITLOCKER_PLUGIN_H_
#define FLUTTER_PLUGIN_BITLOCKER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace bitlocker {

    class BitlockerPlugin : public flutter::Plugin {
    public:
        static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

        BitlockerPlugin();

        virtual ~BitlockerPlugin();

        // Disallow copy and assign.
        BitlockerPlugin(const BitlockerPlugin &) = delete;

        BitlockerPlugin &operator=(const BitlockerPlugin &) = delete;

        // Called when a method is called on this plugin's channel from Dart.
        void HandleMethodCall(
                const flutter::MethodCall <flutter::EncodableValue> &method_call,
                std::unique_ptr <flutter::MethodResult<flutter::EncodableValue>> result);
    };

}  // namespace bitlocker

#endif  // FLUTTER_PLUGIN_BITLOCKER_PLUGIN_H_
