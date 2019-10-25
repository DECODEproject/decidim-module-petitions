# decidim-petitions

[![Build Status](https://img.shields.io/circleci/project/github/alabs/decidim-module-petitions/master.svg)](https://circleci.com/gh/alabs/decidim-module-petitions)
[![Coverage](https://img.shields.io/codeclimate/coverage/alabs/decidim-module-petitions.svg)](https://codeclimate.com/github/alabs/decidim-module-petitions)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/alabs/decidim-module-petitions.svg)](https://codeclimate.com/github/alabs/decidim-module-petitions)

This is the open-source repository for DDDC, based on [Decidim](https://github.com/decidim/decidim),
implementing the [DECODE](https://decodeproject.eu/) prototypes.

## Installation

Add this line to your Gemfile:

```ruby

gem "decidim-petitions",
    git: "https://github.com/alabs/decidim-module-petitions",

```

Run this commands:

```bash

bundle install
rake decidim_petitions:install:migrations
rake db:migrate
```

To use this module you need to have at least running Credentials Issuer API and 
Petition API from DECODE project. To do so:

- Head to Petitions configuration and specify the Cred. Issuer and Petitions API 
URLs as well as user and passwords to interact with them.

- Make sure the petition details are well configured ![](docs/decode-petitions-cog.png).

Then you need to configure the petition with the associated data for the Mobile App. 
For details, see http://app.decodeproject.eu.

### Screenshots

![](docs/decode-petitions-01.png)
![](docs/decode-petitions-02.png)
![](docs/decode-petitions-03.png)
![](docs/decode-petitions-04.png)
![](docs/decode-petitions-05.png)

### JSON Schema and Attributes Authorization

It's important to configure some JSON data so it's consumed by the DECODE's APIs:

## json_schema

This field adds information that any app wishing to interact with the site can use. 
For the moment, it does no require anything beyond the fields specified below as "mandatory":

- Name: Name with translations to identify the petition within the app
- Provenance: Provenance that indicates where the credentials are from (what is shown to 
the user). Must coincide with the credential issuer set up in the system.
- Verification Input: Translations and names for the type of verification chosen (see next 
section).

```json

{
  "mandatory": [
    {
      "name": {
        "ca": "Credencial per participar",
        "en": "Credential to participate",
        "es": "Credencial para participar"
      },
      "provenance": {
        "url": "https://credential-test.dyne.org",
        "issuerName": {
          "ca": "Gestor de credencials DECODE",
          "en": "DECODE Credential Issuer",
          "es": "Gestor de credenciales de DECODE"
        },
        "petitionsUrl": "https://petition-test.dyne.org"
      },
      "verificationInput": [
        {
          "id": "codes",
          "name": {
            "ca": "Codi",
            "en": "Code",
            "es": "Código"
          },
          "type": "string"
        }
      ]
    }
  ]
}
```

## json_attribute_info

This field defines the authorization codes that the credential issuer needs in 
order to issue certificates. In other words, it specifies the codes that allow 
people to gain the right to participate in the support of a petition. Those codes 
can be one-use (if the tick ```is reisuable``` is set to true) or multiple use 
(otherwise).

In the example below, the codes are defined as strings and codenamed "codes". For 
more information, see please [the credential issuer documentation](https://credentials.decodeproject.eu/docs) 
or the repository[https://github.com/DECODEproject/credential-issuer].

WARNING: The first code is going to be used for Petitions API setup.

```json

[{
    "name": "codes",
    "type": "str",
    "value_set": [
      "1234",
      "a_password"
    ]
}]
```

## json_attribute_info_optional

This field defines the optional info that can be attached to the credentials. 
This is used in order to gather anonymous (aggregated) information on the demographics 
of the users that participate in the petitions.

The aggreated information is exposed on the endpoint of the credential issuer /stats.

- The parametter "k" specifies the minimum number of entries needed for a value to be 
shown for privacy reasons.
- The name is the identifier that needs to be compatible with the DECODE Atlas 
(see [APP repo](https://github.com/DECODEproject/decodev2/tree/master/docs) for details)
- The value set is the set of values (ranges) that the data accepts.

All those fields are not free, and must be compatible with the DECODE Atlas file. The 
only option for the admin is to define the "k" security aggregation values.

```json

[
  {
    "k": 2,
    "name": "age",
    "type": "str",
    "value_set": ["0-19", "20-29", "30-39", ">40"]
  },
  {
    "k": 2,
    "name": "gender",
    "type": "str",
    "value_set": ["F", "M", "O"]
  },
  {
    "k": 2,
    "name": "district",
    "type": "str",
    "value_set": ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
  }
]
```

## GraphQL

To consume some data from external services, you can do it on the GraphQL API:

```graphql
{
    petition(id:"1") {
        id,
        title,
        description,
        author,
        json_schema,
        image,
        credential_issuer_api_url,
        petitions_api_url,
        attribute_id
    }
}
```

An example with curl:

```bash
curl 'https://betadddc.alabs.org/api' \
    -H 'content-type: application/json' \
    --data '{
      "query":"{
        petition(id:\"1\") {
          id,
          title,
          description,
          author,
          json_schema,
          image,
          credential_issuer_api_url,
          petitions_api_url,
          attribute_id
        }}"
      }'
```