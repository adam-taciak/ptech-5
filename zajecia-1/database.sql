CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE todos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATE,
    completed BOOLEAN DEFAULT FALSE,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

INSERT INTO categories (name) VALUES
    ('Praca'),
    ('Dom'),
    ('Zakupy'),
    ('Zdrowie'),
    ('Edukacja'),
    ('Rozrywka'),
    ('Podróże'),
    ('Finanse'),
    ('Rodzina'),
    ('Inne');

INSERT INTO todos (title, description, due_date, completed, category_id) VALUES
    ('Zakończyć raport', 'Przygotować raport kwartalny dla zarządu', '2023-11-15', FALSE, 1),
    ('Sprzątanie kuchni', 'Umyć naczynia i wyczyścić blaty', '2023-10-20', FALSE, 2),
    ('Zakupy spożywcze', 'Kupić mleko, chleb, i jajka', '2023-10-21', FALSE, 3),
    ('Wizyta u lekarza', 'Kontrola u dentysty', '2023-10-25', FALSE, 4),
    ('Kurs online', 'Ukończyć kurs SQL na platformie e-learningowej', '2023-11-01', FALSE, 5),
    ('Wieczór filmowy', 'Obejrzeć nowy film w kinie', '2023-10-22', FALSE, 6),
    ('Planowanie wakacji', 'Zarezerwować bilety lotnicze i hotel', '2023-12-01', FALSE, 7),
    ('Budżet miesięczny', 'Przeanalizować wydatki i przychody', '2023-10-30', FALSE, 8),
    ('Spotkanie rodzinne', 'Zorganizować obiad z rodziną', '2023-11-05', FALSE, 9),
    ('Przeczytać książkę', 'Zakończyć czytanie powieści', '2023-11-10', FALSE, 10),
    ('Zadanie projektowe', 'Przygotować prezentację projektu', '2023-11-20', FALSE, 1),
    ('Naprawa kranu', 'Zamówić hydraulika do naprawy kranu', '2023-10-23', FALSE, 2),
    ('Zakupy odzieżowe', 'Kupić nową kurtkę na zimę', '2023-10-24', FALSE, 3),
    ('Ćwiczenia fizyczne', 'Codzienny trening na siłowni', '2023-10-26', FALSE, 4),
    ('Nauka języka', 'Codzienna nauka języka angielskiego', '2023-11-02', FALSE, 5),
    ('Gra planszowa', 'Zagrać w nową grę planszową z przyjaciółmi', '2023-10-27', FALSE, 6),
    ('Rezerwacja hotelu', 'Zarezerwować hotel na weekendowy wypad', '2023-11-03', FALSE, 7),
    ('Podsumowanie finansowe', 'Przygotować raport finansowy dla księgowego', '2023-11-06', FALSE, 8),
    ('Urodziny mamy', 'Zorganizować przyjęcie urodzinowe dla mamy', '2023-11-12', FALSE, 9),
    ('Nowa książka', 'Zakupić nową książkę do kolekcji', '2023-11-15', FALSE, 10),
    ('Prezentacja w pracy', 'Przygotować prezentację na spotkanie zespołu', '2023-11-18', FALSE, 1),
    ('Malowanie pokoju', 'Pomalować ściany w salonie', '2023-10-28', FALSE, 2),
    ('Zakupy online', 'Zamówić nowy laptop przez internet', '2023-10-29', FALSE, 3),
    ('Badania kontrolne', 'Wykonać badania krwi', '2023-11-04', FALSE, 4),
    ('Webinar', 'Uczestniczyć w webinarze o nowych technologiach', '2023-11-07', FALSE, 5),
    ('Koncert', 'Pójść na koncert ulubionego zespołu', '2023-11-09', FALSE, 6),
    ('Planowanie podróży', 'Przygotować plan podróży po Europie', '2023-11-13', FALSE, 7),
    ('Analiza wydatków', 'Przeanalizować wydatki z ostatniego miesiąca', '2023-11-16', FALSE, 8),
    ('Spotkanie z przyjaciółmi', 'Zorganizować spotkanie z przyjaciółmi', '2023-11-19', FALSE, 9),
    ('Nowy projekt', 'Rozpocząć nowy projekt w pracy', '2023-11-21', FALSE, 1);
