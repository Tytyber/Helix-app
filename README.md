# Helix mobile app

Мобильное приложение на Flutter с функциями чата, ленты новостей, хабов, профиля и аутентификации.

## Технологии

- **Flutter SDK** — пользовательский интерфейс
- **Dio** — HTTP-клиент для API-запросов
- **Riverpod** — управление состоянием
- **GoRouter** — навигация
- **Flutter Secure Storage** — хранение токенов и данных
- **Cached Network Image** — загрузка и кэширование изображений
- **JSON Serializable** — сериализация моделей
- **Intl** — локализация и форматирование

## Структура проекта

```
lib/
├── main.dart                # Точка входа
├── models/                  # Модели данных
│   ├── user.dart
│   ├── chat.dart
│   ├── messenge.dart
│   ├── feed_post.dart
│   ├── group.dart
│   ├── group_messenge.dart
│   ├── friend.dart
│   ├── top_hub.dart
│   └── call.dart
├── providers/               # Провайдеры состояния
│   └── providers.dart
├── screens/                 # Экраны приложения
│   ├── auth/
│   │   └── login_screen.dart
│   ├── home/
│   │   └── feed_screen.dart
│   ├── chat/
│   │   ├── chat_screen.dart
│   │   └── chats_list_screen.dart
│   ├── hubs/
│   │   ├── hubs_screen.dart
│   │   └── hub_detail_screen.dart
│   └── profile/
│       └── profile_screen.dart
├── services/                # Сервисы API
│   ├── api_client.dart
│   ├── auth_service.dart
│   ├── chat_service.dart
│   ├── feed_service.dart
│   ├── friend_service.dart
│   ├── group_service.dart
│   ├── hub_service.dart
│   ├── user_service.dart
│   └── call_service.dart
└── widgets/                 # Переиспользуемые виджеты
    ├── feed_post_cart.dart
    └── messenge_bubble.dart
```

## Запуск проекта

1. Убедитесь, что Flutter установлен и доступен в PATH.
2. Установите зависимости:
   ```bash
   flutter pub get
   ```
3. Сгенерируйте код для моделей:
   ```bash
   flutter pub run build_runner build
   ```
4. Запустите приложение:
   ```bash
   flutter run
   ```

## Генерация кода

Проект использует `json_serializable`. При изменении моделей в `models/` выполните:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Навигация

Реализована через `go_router` — маршруты настроены в `main.dart`.

## Авторизация

Используется `auth_service.dart` и `flutter_secure_storage` для хранения токена.

---
