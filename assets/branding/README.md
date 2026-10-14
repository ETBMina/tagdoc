# App branding: one source image

`app-logo.png` is the only image to maintain: a clean transparent 1024 × 1024 PNG with the tag, hole and horizontal pulse. The Flutter header uses this exact file. Keep the artwork centered with small safe margins when replacing it.

## Regenerate application icons

From the project root:

```sh
flutter pub get
dart run icons_launcher:create
```

Configuration lives in `icons_launcher.yaml`; the generator is a development dependency in `pubspec.yaml`. It reads the same source for Android, iOS, macOS, Windows, Web and Linux. No Node.js, Sharp, custom export scripts or per-platform drawing is needed.

After changing the source, regenerate and rebuild the target app. Hot reload does not update the executable's launcher icon. Commit the configuration, source PNG and generated platform resources.

## Generated platform resources

- Android: launcher images under `android/app/src/main/res`.
- iOS: AppIcon asset catalog; the generator removes transparency with a white background as required for the standard icon.
- macOS: AppIcon asset catalog.
- Windows: `windows/runner/resources/app_icon.ico`; `Runner.rc` references this standard generated resource. There is no custom Windows icon-loading code.
- Web: favicon and PWA icon images.
- Linux: icon and desktop entry under `snap/gui`, plus a generated `snap/snapcraft.yaml` starter. Review the Snap package metadata before publishing; other Linux packaging formats must install the generated PNG and desktop entry appropriately.

Generating icons does not certify application runtime support on every platform. The platform builds are validated separately.

Old design alternatives, source drawings, previews and Node scripts are preserved in the Git-ignored `backup/logo-design-archive` folder. They are not bundled with the application.

Tool documentation: https://pub.dev/packages/icons_launcher
