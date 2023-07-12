CREATE TABLE IF NOT EXISTS public.readers (
    reader_id serial PRIMARY KEY,
    number_of_reader_ticket BIGINT NOT NULL,
    reader_fio VARCHAR(255) NOT NULL,
    reader_address VARCHAR(255) NOT NULL,
    reader_phone_number varchar(50) NOT NULL
);
CREATE TABLE IF NOT EXISTS public.cities (
    city_id serial PRIMARY KEY,
    city_name VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS public.authors (
    author_id serial PRIMARY KEY,
    author_fio VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS public.books (
    book_id serial PRIMARY KEY,
    book_cipher BIGINT NOT NULL,
    book_name VARCHAR(255) NOT NULL,
    year_of_publishing_book smallint NOT NULL,
    book_size INTEGER,
    book_priсe numeric(7, 2) NOT NULL DEFAULT 0,
    сount_copies_of_book integer NOT NULL DEFAULT 0
);
CREATE TABLE IF NOT EXISTS public.pub_houses (
    pub_houses_id serial PRIMARY KEY,
    name_pub_houses  VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS public.pub_houses_cities (
    pub_houses_cities_id serial PRIMARY KEY,
    city_id BIGINT REFERENCES public.cities (city_id) ON DELETE CASCADE,
    pub_houses_id BIGINT REFERENCES public.pub_houses (pub_houses_id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS public.authors_books (
    authors_books_id serial PRIMARY KEY,
    book_id BIGINT REFERENCES public.books (book_id) ON DELETE SET NULL,
    author_id BIGINT REFERENCES public.authors (author_id) ON DELETE SET NULL
);
CREATE TABLE IF NOT EXISTS public.copies_of_books (
    copies_of_books_id serial PRIMARY KEY,
    location_of_copie VARCHAR(255) NOT NULL,
    book_id BIGINT REFERENCES public.books (book_id) ON DELETE CASCADE,
    pub_houses_id BIGINT REFERENCES public.pub_houses (pub_houses_id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS public.lending_of_books (
    lending_of_book_id serial PRIMARY KEY,
    lending_date date NOT NULL DEFAULT CURRENT_DATE,
    deadline_time date NOT NULL DEFAULT CURRENT_DATE,
    return_date DATE,
    reader_id BIGINT REFERENCES public.readers (reader_id) ON DELETE CASCADE,
    book_id BIGINT REFERENCES public.books (book_id) ON DELETE SET NULL
);