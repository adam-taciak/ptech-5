# Zajęcia 3 - Dokeryzacja i orkiestracja

## Opis projektu / zadania
Na tych zajęciach zajmiemy się dokerzacją napisanych wcześniej aplikacji.
Cel jest następujący: chcemy zamienić naszą aplikację w obraz dockerowy.
Wewnątrz obrazu będą znajdować się wszystkie potrzebne aplikacje i moduły aby aplikacja działała poprawnie.

Gdy powstaną przygotujemy obrazy frontendu i backendu, przejdziemy do kroku orkiestracji.
Aby całkowicie zautomatyzować proces tworzenia infrastruktury dla naszej aplikacji, napiszemy plik docker-compose który wszystko przygotuje.

## Dokeryzacja

### Backend

W głównym katalogu repozytorium stwórz nowy plik o nazwie `Dockerfile` z następującą zawartością:

```Dockerfile
FROM python:3.13-alpine

WORKDIR /app

COPY . /app

RUN pip install -r requirements.txt

ENTRYPOINT ["python"]
CMD ["app.py"]
```

Następnie wywołaj polecenie aby zbudować obraz. Obraz otrzyma nazwę `ptech-backend`:

```
docker build -t ptech-backend .
```

Gdy obraz się zbuduje, możemy sprawdzić czy działa prawidłowo. Zrobimy to poniższym poleceniem

```
docker run --rm -it -p 3000:3000 ptech-backend
```

Po uruchomieniu sprawdź czy backend działa prawidłowo, otwierając adres aplikacji w przeglądarce, np `http://localhost:3000`.
Aplikacja powinna działać prawidłowo, lecz odwołanie się do endpointu `/todos` wyświetli błąd komunikacji z bazą.
Tym zajmiemy się przy orkiestracji.

### Frontend

W głównym katalogu repozytorium stwórz nowy plik o nazwie `Dockerfile` z następującą zawartością:

```Dockerfile
FROM python:3.13-alpine

WORKDIR /app

COPY . /app

RUN pip install -r requirements.txt

ENTRYPOINT ["python"]
CMD ["app.py"]
```
