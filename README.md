# ImageLoader

# Проект с использованием UICollectionView

Этот проект демонстрирует работу с `UICollectionView`, загрузкой изображений из сети и их отображением в полноэкранном режиме при нажатии. В проекте также реализована пагинация данных.

## Требования

- Xcode 12.0 или выше
- iOS 16.0 или выше
- Swift 5.0 или выше

## Установка и запуск проекта

1. **Склонируйте репозиторий**
    ```sh
    git clone https://github.com/yourusername/yourproject.git
    cd yourproject
    ```

2. **Откройте проект в Xcode**
    ```sh
    open yourproject.xcodeproj
    ```

3. **Установите зависимости**
    Если проект использует CocoaPods, выполните:
    ```sh
    pod install
    open yourproject.xcworkspace
    ```

4. **Запуск проекта**
    - Выберите целевое устройство или симулятор в Xcode.
    - Нажмите кнопку "Run" (или используйте сочетание клавиш `Cmd + R`).

## Использование приложения

1. **Главный экран**
    - На главном экране отображается коллекция изображений, загруженных из сети.
    - Прокрутите вниз, чтобы увидеть больше изображений.

2. **Загрузка дополнительных данных**
    - Когда вы прокручиваете до конца коллекции, отображается индикатор загрузки, и автоматически загружаются дополнительные данные.

3. **Просмотр изображения в полноэкранном режиме**
    - Нажмите на любое изображение, чтобы открыть его в полноэкранном режиме.
    - В полноэкранном режиме нажмите на изображение еще раз, чтобы закрыть его и вернуться к коллекции.

## Основные компоненты проекта

- **ViewController.swift**
    - Основной `UIViewController`, содержащий `UICollectionView` и реализующий логику загрузки и отображения данных.
    
- **ImageViewController.swift**
    - `UIViewController` для отображения изображения в полноэкранном режиме.
    
- **CollectionViewCell.swift**
    - Класс для настройки ячейки `UICollectionView`.

- **LoadingFooterView.swift**
    - Класс для футера с индикатором загрузки, отображаемого при достижении конца коллекции.


## Примечания

- **Асинхронная загрузка данных**: Используется для загрузки изображений и данных с сервера.
- **Пагинация**: Реализована с помощью отслеживания прокрутки и отображения футера с индикатором загрузки.
- **Полноэкранное изображение**: При нажатии на ячейку открывается новый `UIViewController` с увеличенным изображением.



