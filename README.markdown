# API RESTful para controle de usuários e grupos de acesso
API RESTful que fornece a criação, visualização, inserção e remoção de usuários, grupos de acesso e relações entre os dois.

Pode ser usada em uma rede intranet ou internet, contudo, é necessário um token para fazer requisições caso elas venham de fora da rede local.

## Pré-requisitos
* SBCL (Steel Bank Common Lisp)
* Quicklisp

## Usando a aplicação localmente no GNU/Linux
Para usar a aplicação, é necessário o SBCL, um compilador de Common Lisp. Com ele instalado, é possível instalar o Quicklisp, que é uma ferramenta para administrar as dependências. Após instalar ambos, rode o quicklisp com o seguinte comando:
```
sbcl --script ~/quicklisp/setup.lisp
```
Para carregar a aplicação e suas dependências, a aplicação precisa estar na pasta *common-lisp* no diretório *home* criada quando o SBCL é instalado, o seguinte comando para carregar a aplicação é:
```
(ql:quickload :rest-api)
```
Contudo, o servidor ainda não terá sido iniciado, para iniciar ele na porta 5000, use:
```
(rest-api:main)
```
O ínicio do servidor, por ora, não é parametrizado.

## Usando a API
### Métodos
Requisições para a API devem seguir os padrões:
| Método | Descrição |
|---|---|
| `GET` | Retorna informações pertinentes a grupos, usuários e de suas relações |
| `POST` | Cria registros válidos |
| `PUT` | Adiciona usuários a um grupo de acesso |
| `DELETE` | Remove usuários de um grupo de acesso |



### Respostas
| Código | Descrição |
|---|---|
| `200` | Requisição executada com sucesso |
| `400` | Dados inválidos em relação à necessidade do sistema |
| `401` | Dados de acesso inválidos/inexistentes |

# Usuário

## GET endpoints

### Retorna todos os usuários ativos do sistema que participam de pelo menos um grupo de acesso 
### [GET /user/{id}]

+ Request (application/json)

    + Headers

            X-Access-Token: token

+ Response 200 (application/json)
    + Body
```
    {
        "name": "felipe",
        "password": "senha-forte",
        "email": "felipe@felipe.com",
        "status": "active",
        "kind": "admin"
    },
```

## POST endpoints

### Registra um usuário caso o email não esteja cadastrado
### [POST /user/sign-up]
+ Request (application/json)
    + Body
        + Parameters
            + name - *nome do usuário*
            + password - *senha do usuário*
            + email - *e-mail do usuário*
            + kind - *tipo de usuário, podendo ser "admin", "buyer", ou "seller"*
+ Response 200 (application/json)
    + Body
```
{
    "successo": 1,
    "message": "Usuário criado com sucesso"
}
```

+ Response 400 (application/json)
    + Body
```
{
    "erro": 2,
    "mensagem":"Nome inválido"
},
```

+ Response 200 (application/json)
    + Body
```
{
    "erro": 3,
    "mensagem":"Sobrenome inválido"
},
```

+ Response 400 (application/json)
    + Body
```
{
    "erro": 1,
    "mensagem":"{e-mail} já existe"
},
```
## PUT endpoints

### Retorna um token de autenticação caso o e-mail e a senha estejam cadastrados em um usuário
### [PUT /user/{id}]
+ Request (application/json)
    + Body
        + Parameters
            + name - *nome do usuário*
            + password - *senha do usuário*
            + email - *e-mail do usuário*
            + kind - *tipo de usuário, podendo ser "admin", "buyer", ou "seller"*
+ Response 200 (application/json)
    + Body
```
{
    "successo": 1,
    "message": "Usuário criado com sucesso"
}
```

+ Response 400 (application/json)
    + Body
```
{
    "erro": 2,
    "mensagem":"Nome inválido"
},
```

+ Response 200 (application/json)
    + Body
```
{
    "erro": 3,
    "mensagem":"Sobrenome inválido"
},
```

+ Response 400 (application/json)
    + Body
```
{
    "erro": 1,
    "mensagem":"{e-mail} já existe"
},
```

## DELETE endpoints

### Remove um usuário do sistema
### [DELETE /user/{id}]

+ Request (application/json)

    + Headers

            X-Access-Token: token

+ Response 200 (application/json)
    + Body
```
{
    "successo": 1,
    "message": "{usuário} deletado com sucesso"
},
```
+ Response 400 (application/json)
    + Body
```
{
    "erro": 4,
    "mensagem":"{usuário} não existe"
},
```

# Administrador

## GET endpoints

### Retorna todos os usuários cadastrados n
### [GET /admin/users]

+ Request (application/json)

    + Headers

            X-Access-Token: token

+ Response 200 (application/json)
    + Body
```
[
   {
        "name": "felipe",
        "password": "senha-forte",
        "email": "felipe@felipe.com",
        "status": "active",
        "kind": "admin",
    },
    {
        "name": "felipe",
        "password": "senha-forte",
        "email": "felipe@felipe.com",
        "status": "active",
        "kind": "admin"
    },
    {
        "name": "felipe",
        "password": "senha-forte",
        "email": "felipe@felipe.com",
        "status": "active",
        "kind": "admin"
    },
]
```

## POST endpoints

### Retorna um token com poderes administrativos
### [POST /api/team/create]
+ Parameters
    + email - *e-mail do administrador*
    + password - *senha do administrador*
+ Request (application/json)

+ Response 200 (application/json)
    + Body
```
{
    "successo": 1,
    "message": "Usuário criado com sucesso"
}
```
+ Response 400 (application/json)
    + Body
```
{
    "erro": 2,
    "mensagem":"Nome inválido"
},
```