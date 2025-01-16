# Zajęcia 1 - Backend (oraz przygotowanie środowiska)

Wymagania aplikacji i środowiska:

- Python
- Flask
- MySQL
- Docker
- Środowisko deweloperskie w systemie Linux

## Opis projektu / zadania

Celem zadania jest przygotowanie prostej aplikacji realizującej
backend dla listy zadań (to-do). Aplikacja powinna powstać w oparciu
o bibliotekę **Flask**, więc wiąże się z tym język Python.

Dodatkowo dane będą przechowywane w bazie danych MySQL. Nie ma potrzeby instalowania
bazy w systemie, należy skorzystać z dockera.

### API
Backend powinien wystawić REST API z następującymi endpointami:

- GET /todos - lista zadań
- POST /todos - tworzenie nowego zadania
- GET /todos/{id} - zadanie o podanym id
- PUT /todos/{id} - edycja zadania o podanych id
- DELETE /todos/{id} - usuwanie zadania o podanym id
- GET /categories - lista kategorii

Schemat danych jest następujący.

Zadanie `todo`:

```json
{
	"category_id": 3,
	"completed": 0,
	"description": "test",
	"due_date": "Tue, 28 Jan 2025 00:00:00 GMT",
	"id": 40,
	"title": "test"
}
```

Kategoria `category`:

```json
{
	"category_id": 3,
	"category_name": "Dom"
}
```

### Bazda danych

Do realizacji zadania, należy wykorzystać bazę MySQL. Dane aplikacji
będą przechowywane w bazie o nazwie `app`. Baza będzie posiadać dwie tabele:
`totos` i `categories`. Schemat tabel.

```sql
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
```

Plik z całą bazą dostępny jest tu [database.sql](https://github.com/adam-taciak/ptech-5/blob/master/zajecia-1/database.sql)

## Przygotowanie środowiska

- Stworzenie konta na GitHubie (można pominąć jeżeli posiadasz już konto)
- Stworzenie repozytorium `backend` na GitHubie
- Stworzenie i dodanie klucza SSH do GitHuba
- Instalacja/Przygotowanie systemu operacyjnego Linux
- Instalacja Dockera
- Instalacja Pythona
- Stworzenie katalogu o nazwie `backend`
- Stworzenie środowiska wirtualnego `.venv` w katalogu `.venv`
- Instalacja zależności `pip install -r requirements.txt`

## Aplikacja

- Stworzenie pliku `docker-compose.yaml` i uruchomienie infrastruktury deweloperskiej (MySQL + phpmyadmin)
- Stworzenie pliku `app.py` i rozpoczęcie implementacji

### docker-compose

Aby ułatwić pracę na etapie dewelopmentu, należy wykorzystać narzędzie **docker compose**,
które błyskawicznie podniesie wymaganą infrastrukturę. Poniżej zawartość pliku `docker-compose.yaml`
który należy stworzyć.

```yaml
services:
  db:
    image: mysql:latest
    container_name: db
    environment:
      MYSQL_ROOT_PASSWORD: my_secret_password
      MYSQL_DATABASE: app
      MYSQL_USER: user
      MYSQL_PASSWORD: password
    ports:
      - "6033:3306"
    volumes:
      - dbdata:/var/lib/mysql
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: pma
    links:
      - db
    environment:
      PMA_HOST: db
      PMA_PORT: 3306
      PMA_ARBITRARY: 1
    restart: always
    ports:
      - 8081:80
volumes:
  dbdata:
```

Po przygotowaniu pliku należy wykonać polecenie `docker compose up -d` co spowoduje pobranie obrazów
oraz uruchomienie kontenerów. Pod adresem `http://localhost:8081` dostępny będzie phpMyAdmin.

### Przygotowanie bazy danych

Przed rozpoczęciem dewelopmentu, należy przygotować bazę danych. Konieczne jest stworzenie twóch tabel
`todos` oraz `categories`. Tabele najlepiej jest wypełnić danymi aby usprawnić dewelopment.

Należy uruchomić w przeglądarce phpMyAdmin (**login:** `user`, **hasło**: `password`), przejść do bazy `app`,
uruchomić edytor zapytań, skopiować zawartość pliku [database.sql](https://github.com/adam-taciak/ptech-5/blob/master/zajecia-1/database.sql)
i wykonać zapytania. Powstaną tabele które będą wypełnione danymi.

### Zależności (requirements.txt)

Backend korzysta z 3 modułów które należy doinstalować:

- Flask
- Flask-CORS
- Mysql Connector/Python

Aby zainstalować zależności, należy stworzyć w projekcie nowy plik o nazwie `requirements.txt` i skopiować
[requirements.txt](https://github.com/adam-taciak/ptech-5/blob/master/zajecia-1/requirements.txt)

Ostatnim krokiem jest wykonanie polecenia `pip install -r requirements.txt`.

> [!WARNING]
> Należy wcześniej aktywować środowisko wirtualne `venv`.

### Kod aplikacji

> [!TIP]
> Przed rozpoczęciem implementacji warto zapoznać się z krótkim wstępem do Flaska [Flask Quickstart](https://flask.palletsprojects.com/en/stable/quickstart/).

#### Część wspólna

Import modułów, stworzenie obiektu aplikacji (`app`), rejestracja middleware (`CORS`).

```python
from flask import Flask, request, Response
from flask_cors import CORS
from db import connect, disconnect

app = Flask(__name__)

CORS(app)
```

Uruchomienie aplikacji.

```python
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000, debug=True)
```

Po stworzeniu pliku `app.py` i wstawieniu powyższego kodu, należy uruchomić aplikację poleceniem `python app.py`.

#### Endpointy zadań `/todos`, `/todos/id`

##### GET, POST`/todos`

```python
@app.route('/todos', methods=['GET', 'POST'])
def get_todos():
    db = connect()
    cursor = db.cursor(dictionary=True)

    if request.method == 'GET':
        sql = 'SELECT * FROM todos ORDER BY id DESC'
        cursor.execute(sql)

        todos = cursor.fetchall()

        disconnect(db)
        return todos

    if request.method == 'POST':
        title = request.json.get('title')
        description = request.json.get('description')
        due_date = request.json.get('due_date')
        completed = request.json.get('completed')
        category = request.json.get('category')

        # Dummy date formatter. The DB stores due_date in the following format YYYY-MM-DD.
        due_date = due_date[:10]
        params = title, description, due_date, completed, str(category)
        sql = '''
            INSERT INTO
                todos (id, title, description, due_date, completed, category_id)
            VALUES
                (NULL, %s, %s, %s, %s, %s)
        '''

        cursor.execute(sql, params)
        db.commit()

        disconnect(db)
        return {}
```

##### GET, PUT, DELETE `/todos/{id}`

```python
@app.route('/todos/<int:todo_id>', methods=['GET', 'DELETE', 'PUT'])
def handle_todo(todo_id):
    db = connect()
    cursor = db.cursor(dictionary=True)
    params = (todo_id, )

    if request.method == 'GET':
        sql = '''
            SELECT
                id, title, description, due_date, completed, category_id)
            FROM
                todos
            WHERE id = %s
        '''

        cursor.execute(sql, params)
        todo = cursor.fetchall()

        disconnect(db)
        return todo

    if request.method == 'PUT':
        pass

    if request.method == 'DELETE':
        sql = 'DELETE FROM todos WHERE id = %s'

        cursor.execute(sql, params)
        db.commit()

        disconnect(db)
        return Response('', status=200)
```

#### Endpointy kategorii `/categories`

##### GET `/categories`

```python
@app.route('/categories', methods=['GET'])
def get_categories():
    db = connect()
    cursor = db.cursor(dictionary=True)

    sql = 'SELECT * FROM categories'

    cursor.execute(sql)
    categories = cursor.fetchall()

    disconnect(db)
    return categories
```


## Referencje
- [Virtual Environments and Packages](https://docs.python.org/3/tutorial/venv.html)
- [Flask Quickstart](https://flask.palletsprojects.com/en/stable/quickstart/)
- [MySQL Connector Example](https://dev.mysql.com/doc/connector-python/en/connector-python-tutorial-cursorbuffered.html)
- [GitHub - Generate new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- [GitHub - Adding a new SSH key to your account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
- [Docker Compose cheatsheet](https://devhints.io/docker-compose)
- [Awesome Docker Compose samples](https://github.com/docker/awesome-compose?tab=readme-ov-file)
- [Docker installation on Ubuntu](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)
