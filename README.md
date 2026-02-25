# Список персонажей Рика и Морти

Мобильное приложение на Flutter для просмотра персонажей мультсериала "Рик и Морти".

***

## Функционал

### 1. Главный экран (Список персонажей)
- Карточки: фото, имя, статус
- Кнопка "звездочка" — добавление в избранное


<img src="https://github.com/user-attachments/assets/24fb8ee0-1222-4c2f-88f6-9511e956dfbc" width="200">
<img src="https://github.com/user-attachments/assets/f4f5e39d-e8ae-4a76-94f3-a9a7f1ea17d3" width="200">


### 2. Экран "Избранное"  
- Список только избранных персонажей
- **Сортировка**: алфавит (A→Z, Z→A), дата обновления
- **Фильтр**: статус (Alive/Dead/Unknown)  
- Удаление из избранного


<img src="https://github.com/user-attachments/assets/62af41d6-921c-4699-928a-bfaa0521feb3" width="200">
<img src="https://github.com/user-attachments/assets/67a40231-839c-4e9a-b290-b642b15a2e00" width="200">


### 3. Настройки
- Переключатель темы (темная/светлая)
- Выбор языка


<img src="https://github.com/user-attachments/assets/91773619-414e-40a2-91f5-643cf7b091c0" width="200">
<img src="https://github.com/user-attachments/assets/9fc22318-63f6-4b69-95cc-56f9a604dccc" width="200">


***

## Установка

<div align="center">

<img width="200" height="200" alt="image" src="https://github.com/user-attachments/assets/64d212f6-b09a-41bb-8d0c-82c3017d77c5" />


**Rick and Morty Android**

[![Download APK](https://img.shields.io/badge/Download-APK-brightgreen?style=for-the-badge&logo=android)](https://github.com/EkaEkaEkaRy/RickAndMorty/releases)

</div>


***

## Запуск

1. **Клонировать репозиторий:**
```bash
git clone https://github.com/EkaEkaEkaRy/RickAndMorty.git
```

2. **Создать `.env`:**
```
// .env
API_BASE_URL=https://rickandmortyapi.com/api
```

3. **Установить зависимости:**
```bash
flutter pub get
```

4. **Запуск:**
```bash
cd test_effective_mobile
flutter run
```

## Сборка

```bash
# APK
flutter build apk --release
```

***

## Версии

- **Flutter**: 3.41.2 -  Dart 3.11.0
- **Android**: API 21+ (5.0+)

## Зависимости

```
flutter_bloc: ^9.1.1          # Управление состоянием (BLoC)
provider: ^6.1.2              # Dependency Injection (Глобальные настройки)
sqflite: ^2.4.2               # Локальная БД (кэш + избранное)
http: ^1.6.0                  # Запросы к Rick and Morty API
shared_preferences: ^2.5.3    # Сохранение темы/языка
flutter_gen: ^5.12.0          # Генерация ресурсов (локализация)
```
