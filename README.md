# A Discord Bot for UWO

## Description

This bot is use to learn and answer words. Simply put, it's an agent to
read/write a dictionary which provides "kind-of" fuzzy string searching.

## Specification

* A word itself is the `key` to look up the dictionary.
* A word may or may not have its own `type`.
* A word must contain its description/definition, called `value` here.
* Only user with specific `Role` can update (`learn`/`forget`) the dictionary.

|                                               | query with `type`                                           | query without `type`                                                                                            |
|-----------------------------------------------|-------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------|
| both exact and approximate words are found    | Return the exact word's `value`.                            | Show the exact word's `value` with a note of other possible words.                                              |
| only exact word is found                      | Return the exact word's `value`.                            | Return the exact word's `value`.                                                                                |
| only approximate words are found              | Show "not found" error with a note of other possible words. | Show the first word's `value` if only one possible word is found. Otherwise, show a note of all possible words. |
| neither exact nor approximate words are found | Show "not found" error.                                     | Show "not found" error.                                                                                         |

## Interaction Commands

### `ask`

Syntax

```
!ask [type_]key
```

Examples

```
# Query with type.
!ask type1_item1

# Query without type.
!ask item1
```

### `learn`

Syntax

```
!learn [type_]key value
```

Examples

```
# Upsert a word with type.
!learn type1_item1 my description

# Upsert a word without type.
# Note that the un-typed word is distinct from typed ones, i.e. other typed
# words would be intact.
!learn item1 other description
```

### `forget`

Syntax

```
!forget [type_]key
```

Examples

```
# Delete a word with type.
!forget type1_item1

# Delete a word without type.
# Note that the un-typed word is distinct from typed ones, i.e. other typed
# words would be intact.
!forget item1
```

## Service-Related Commands

* To start the bot service

    Note that create a file named `.env` in the root of the project's directory
    and fill it with values properly before running the service.

    ```
    docker-compose up -d
    ```

* To stop the bot service

    ```
    docker-compose down
    ```

* If you modified the code and would like to apply the changes

    ```
    docker-compose build
    ```

* To dump data saved in the database to a file

    ```
    docker-compose exec -T db sh -c 'mongodump --archive --db=uwo_dictionary_bot' > {BACKUP_FILE_PATH}
    ```

* To restore data from a backup file to the database

    ```
    docker-compose exec -T db sh -c 'mongorestore --archive --nsInclude="uwo_dictionary_bot.*"' < {BACKUP_FILE_PATH}
    ```
