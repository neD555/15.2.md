### Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки»
### Задание 1. Yandex Cloud

Что нужно сделать:

1.Создать бакет Object Storage и разместить в нём файл с картинкой:

    Создать бакет в Object Storage с произвольным именем (например, имя_студента_дата).
    Положить в бакет файл с картинкой.
    Сделать файл доступным из интернета.

2.Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

    Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать image_id = fd827b91d99psvq5fjit.
    Для создания стартовой веб-страницы рекомендуется использовать раздел user_data в meta_data.
    Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.
    Настроить проверку состояния ВМ.

3.Подключить группу к сетевому балансировщику:

    Создать сетевой балансировщик.
    Проверить работоспособность, удалив одну или несколько ВМ.

### Ответ.
<img width="657" height="419" alt="дз1(1)" src="https://github.com/user-attachments/assets/124d880b-19a2-413b-8b06-99d28f9521b1" />
<img width="522" height="294" alt="дз1(2)" src="https://github.com/user-attachments/assets/324766c9-6160-4ad4-9d59-61d51dfc81a6" />
<img width="619" height="407" alt="дз1(3)" src="https://github.com/user-attachments/assets/90cc7b36-d18d-4f8f-a9d9-4559395bde95" />
<img width="656" height="360" alt="дз1(4)" src="https://github.com/user-attachments/assets/8919b011-0b17-43c1-bd51-2a8eb421b125" />
<img width="659" height="49" alt="дз1(5)" src="https://github.com/user-attachments/assets/ea4ad2fe-3c5e-4f6b-a995-cca6d8e61f83" />
<img width="657" height="250" alt="дз1(6)" src="https://github.com/user-attachments/assets/bd1d5b9e-24c4-4314-8dcb-1f2014cd3ede" />


