# Speaq

## Required Programs

- Make
- Flutter + Dart
- Go
- GCC (C-Compiler)
- Docker
- Docker Compose (optional for build)

## How to setup/install

Clone the Git repository and go into the directory

```
git clone https://github.com/speaq-app/speaq
cd speaq
```

Now generate all the necessary files with
```
make build
```

### Build the backend

This will create a binary executable of the backend:
```
cd speaq/backend
make compile
```
The executable can be found in speaq/backend

### Build the frontend

This will create an APK of the frontend:
```
cd speaq/frontend
make compile
```
The APK can be found in speaq/frontend/build/app/outputs/flutter-apk