-- Определить, сколько книг прочитал каждый читатель в текущем году.
-- Вывести рейтинг читателей по убыванию.

SELECT r.reader_fio AS "Читатель", COUNT(lb.book_id) AS "Книг прочитано"
FROM readers AS r
LEFT JOIN lending_of_books AS lb USING(reader_id)
WHERE lb.return_date IS NOT NULL AND EXTRACT(YEAR FROM lb.lending_date::date) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY r.reader_fio
ORDER BY "Книг прочитано" DESC;

-- Определить, сколько книг у читателей на руках на текущую дату.
SELECT r.reader_id, r.reader_fio, COUNT(l.book_id) AS "Общее количество книг у читателей"
FROM public.readers r
LEFT JOIN public.lending_of_books l ON r.reader_id = l.reader_id
WHERE l.return_date IS NULL OR l.return_date > CURRENT_DATE
GROUP BY r.reader_id, r.reader_fio;

-- Определить читателей, у которых на руках определенная книга.
SELECT r.reader_fio AS "Читатель"
FROM readers AS r
LEFT JOIN lending_of_books AS lb ON r.reader_id = lb.reader_id
WHERE lb.return_date IS NULL AND lb.book_id = (
    SELECT book_id
    FROM books
    WHERE book_name = 'Бегущий человек'
    LIMIT 1 -- Добавим ограничение, чтобы подзапрос вернул только один book_id
);

-- Определите, какие книги на руках читателей.
SELECT r.reader_fio AS "Читатель", b.book_name AS "Название книги", l.lending_date AS "Дата выдачи"
FROM readers AS r
JOIN lending_of_books AS l ON r.reader_id = l.reader_id
JOIN books AS b ON l.book_id = b.book_id
WHERE l.return_date IS NULL;

-- Вывести количество должников на текущую дату.
SELECT COUNT(DISTINCT reader_id) AS "Количество должников"
FROM lending_of_books
WHERE return_date IS NULL AND deadline_time < CURRENT_DATE;

-- Книги какого издательства были самыми востребованными у читателей?
-- Отсортируйте издательства по убыванию востребованности книг.
SELECT ph.name_pub_houses AS "Издательство", COUNT(l.book_id) AS "Количество книг"
FROM pub_houses AS ph
JOIN copies_of_books AS cb ON ph.pub_houses_id = cb.pub_houses_id
JOIN lending_of_books AS l ON cb.book_id = l.book_id
WHERE l.return_date IS NULL
GROUP BY ph.name_pub_houses
ORDER BY COUNT(l.book_id) DESC;

-- Определить самого издаваемого автора.
SELECT a.author_fio AS "Автор", SUM(b.сount_copies_of_book) AS "Количество экземпляров"
FROM authors AS a
LEFT JOIN authors_books AS ab ON a.author_id = ab.author_id
LEFT JOIN books AS b ON ab.book_id = b.book_id
GROUP BY a.author_fio
HAVING SUM(b.сount_copies_of_book) = (
    SELECT SUM(b.сount_copies_of_book) AS "Количество экземпляров"
    FROM authors_books AS ab
    JOIN books AS b ON ab.book_id = b.book_id
    GROUP BY ab.author_id
    ORDER BY "Количество экземпляров" DESC
    LIMIT 1
);

-- Определить среднее количество прочитанных страниц читателем за день.
SELECT r.reader_fio AS "Читатель",
       (SUM(b.book_size) / SUM(lb.days_for_read)) AS "Среднее кол-во прочит. страниц"
FROM readers AS r
LEFT JOIN (
    SELECT reader_id, book_id,
           (return_date - lending_date) AS days_for_read
    FROM lending_of_books
    WHERE return_date IS NOT NULL
) AS lb USING(reader_id)
LEFT JOIN books AS b USING(book_id)
GROUP BY r.reader_fio
ORDER BY 2 DESC NULLS LAST;


