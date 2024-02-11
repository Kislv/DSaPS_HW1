# Приведение типов данных

В исходных таблицах есть следующие атрибуты, типы которых необходимо изменить:
* "transaction_date" имел текстовый тип, приводим к типу "date"
    ```
    ALTER TABLE transactions  ALTER COLUMN transaction_date TYPE date USING cast(transaction_date as date);
    ```
* "online_order" имеет текстовый тип. Мы приводим к типу "bool". Пустую строку преобразуем в null:
    ```
    ALTER TABLE transactions  ALTER COLUMN online_order TYPE bool USING cast((case online_order when '' then null else online_order end) as bool);
    ```
* "DOB" имеет текстовый тип. Приводим к типу "date". Пустую строку преобразуем в null
    ```
    ALTER TABLE customers  ALTER COLUMN DOB TYPE date USING cast((case DOB when '' then null else DOB end) as date);
    ```
* "deceased_indicator" имеет текствовый тип. Приводим к типу "bool". Значений null нет.
    ```
    ALTER TABLE customers  ALTER COLUMN deceased_indicator TYPE bool USING case deceased_indicator when 'Y' then true when 'N' then false end;
    ```
* "owns_car" имеет текстовый тип. Приводим к типу "bool". Значений null нет.
    ```
    ALTER TABLE customers  ALTER COLUMN owns_car TYPE bool USING case owns_car when 'Yes' then true when 'No' then false end;
    ```