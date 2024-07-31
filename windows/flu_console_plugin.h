#ifndef FLUTTER_PLUGIN_FLU_CONSOLE_PLUGIN_H_
#define FLUTTER_PLUGIN_FLU_CONSOLE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flu_console {

class FluConsolePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FluConsolePlugin();

  virtual ~FluConsolePlugin();

  // Disallow copy and assign.
  FluConsolePlugin(const FluConsolePlugin&) = delete;
  FluConsolePlugin& operator=(const FluConsolePlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flu_console

#endif  // FLUTTER_PLUGIN_FLU_CONSOLE_PLUGIN_H_
