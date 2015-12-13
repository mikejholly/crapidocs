## Endpoints

* [/people](#people)
* [/people/:person_id](#peoplepersonid)

## Details

### <a name="people"></a>/people

#### GET


Example response:

```json
[
  {
    "name": "Mike",
    "id": 1,
    "occupation": "Developer",
    "gender": "Male"
  }
]
```

#### POST

Parameters:

```json
{
  "name": "Bob"
}
```

Example response:

```json
{
  "name": "Mike",
  "id": 1,
  "occupation": "Developer",
  "gender": "Male"
}
```


### <a name="peoplepersonid"></a>/people/:person_id

#### GET


Example response:

```json
{
  "name": "Mike",
  "id": 1,
  "occupation": "Developer",
  "gender": "Male"
}
```


