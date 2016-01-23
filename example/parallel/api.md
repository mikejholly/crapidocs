## Endpoints

* [/people](#people)
* [/people/:person_id](#peoplepersonid)
* [/places](#places)
* [/places/:place_id](#placesplaceid)

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


### <a name="places"></a>/places

#### GET


Example response:

```json
[
  {
    "name": "Vancouver",
    "id": 1,
    "weather": "Rainy"
  }
]
```

#### POST

Parameters:

```json
{
  "name": "Vancouver"
}
```

Example response:

```json
{
  "name": "Vancouver",
  "id": 1,
  "weather": "Rainy"
}
```


### <a name="placesplaceid"></a>/places/:place_id

#### GET


Example response:

```json
{
  "name": "Vancouver",
  "id": 1,
  "weather": "Rainy"
}
```


