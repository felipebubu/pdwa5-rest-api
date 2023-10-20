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

# Autenticação

## POST endpoints

### Registra um administrador do sistema, necessário para a obtenção do token
### [POST /api/admin/register]
+ Parameters
    + name - *nome do admin*
    + password - *senha do admin*

+ Request (application/json)

+ Response 200 (application/json)
    + Body
```
{
    "name": "admin",
    "password": "admin"
}
```

+ Response 400 (application/json)
    + Body
```
{
    "erro": 1,
    "mensagem": "Administrador criado com sucesso"
}
```

+ Response 400 (application/json)
    + Body
```
{
    "erro": 1,
    "mensagem": "{administrador} já existe"
}
```

### Gera um token que deve ser usado posteriormente no header 'X-Access-Token' em todas as requisições
### [POST /api/auth/login]
+ Parameters
    + name - *nome do admin*
    + password - *senha do admin*

+ Request (application/json)

    + Headers

            X-Access-Token: token

+ Response 200 (application/json)
    + Body
```
{
    "autenticação": "true",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyIxIjoxLCJpYXQiOjE2NTYzMjExNTEsImV4cCI6MTY1NjMyNDc1MX0.4NZGpHt5tk4CGBO1u6i21WFR9m93dQ4h2qsdUMeMK2A"
}
```

+ Response 400 (application/json)
    + Body
```
{
    "erro": 8,
    "mensagem": "Não foi possível autenticar seu token"
}
```
+ Response 401 (application/json)
+ Resposta padrão para toda requisição sem token
    + Body
```
{
    erro: 7,
    mensagem:"Nenhuma identificação providenciada"
}
```

### Muda a senha de um administrador do sistema
### [POST /api/admin/password]
+ Parameters
    + name - *nome do admin*
    + password - *senha do admin*

+ Request (application/json)

    + Headers

            X-Access-Token: token

+ Response 200 (application/json)
    + Body
```
{
    "sucesso": 1,
    "mensagem": "Senha trocada com sucesso"
}
```

+ Response 400 (application/json)
    + Body
```
{
    "erro": 1,
    "mensagem": "{administrador} já existe"
}
```


# Usuário

## GET endpoints

### Retorna todos os usuários ativos do sistema que participam de pelo menos um grupo de acesso 
### [GET /api/user/all_active]

+ Request (application/json)

    + Headers

            X-Access-Token: token

+ Response 200 (application/json)
    + Body
```
[
    {
        "name": "Simone",
        "surname": "Márcia",
        "email": "simone_marcia_peixoto@atualmarcenaria.com.br",
        "active": 1,
        "user_team": "Office"
    },
    {
        "name": "Ryan",
        "surname": "Theo",
        "email": "ryan-pereira98@hormail.com",
        "active": 1,
        "user_team": "Logístico"
    }
]
```

### Retorna todas as informações de um usuário
### [GET /api/user/{email}/info]

+ Request (application/json)

    + Headers

            X-Access-Token: token

+ Response 200 (application/json)
    + Body
```
[
    "enzoleandrocastro@yahoo.de",
    "simone_marcia_peixoto@atualmarcenaria.com.br",
    "ryan-pereira98@hormail.com"
]
```
+ Response 400 (application/json)
+ caso o usuário não exista
    + Body
```
{
    "código": 6,
    "mensagem": "{usuário} não existe no banco de dados"
}
```

### Retorna todos os grupos que um usuário faz parte
### [GET /api/user/{email}/teams]

+ Request (application/json)

    + Headers

            X-Access-Token: token

+ Response 200 (application/json)
    + Body
```
[
    "Crédito",
    "Office"
]
```

## POST endpoints

### Cria um usuário caso ele não exista e o e-mail inserido seja válido
### [POST /api/user/create]
+ Parameters
    + name - *primeiro nome do usuário*
    + surname - *segundo nome do usuário*
    + email - *e-mail do usuário*

+ Request (application/json)

    + Headers

            X-Access-Token: token

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
### [DELETE /api/user/{usuário}]

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

# Grupo de acesso

## GET endpoints

### Retorna todos os usuários que fazem parte de um grupo
### [GET /api/team/{grupo}/users]

+ Request (application/json)

    + Headers

            X-Access-Token: token

+ Response 200 (application/json)
    + Body
```
[
    "bryan.claudio.ramos@portalpublicidade.com.br",
    "enzoleandrocastro@yahoo.de",
    "simone_marcia_peixoto@atualmarcenaria.com.br"
]
```

## POST endpoints

### Cria um time caso o usuário exista e nome seja válido
### [POST /api/team/create]
+ Parameters
    + name - *primeiro nome do usuário*

+ Request (application/json)

    + Headers

            X-Access-Token: token

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
## PUT endpoints

### Adiciona um usuário a um grupo de acesso
### [PUT /api/team/add]
+ Parameters
    + email - *e-mail do usuário*
    + team - *nome do grupo de acesso*

+ Request (application/json)

    + Headers

            X-Access-Token: token

+ Response 200 (application/json)
    + Body
```
{
    sucesso: 1,
    mensagem: "Usuário adicionado ao grupo de acesso com sucesso"
}
```

+ Response 400 (application/json)
    + Body
```
{
    "erro": 6,
    "mensagem":"{usuário/grupo} não existe"
}
```

+ Response 400 (application/json)
    + Body
```
{
    "erro": 5,
    "mensagem":"Usuário já está no grupo de acesso"
},
```

## DELETE endpoints

### Remove um usuário de um grupo de acesso
### [DELETE /api/team/{grupo}/delete/{email}]

+ Request (application/json)

    + Headers

            X-Access-Token: token

+ Response 200 (application/json)
    + Body
```
{
    "successo": 1,
    "message": "Usuário removido do grupo com sucesso"
},
```
+ Response 400 (application/json)
    + Body
```
{
    "erro": 4,
    "mensagem":"Usuário não está no grupo de acesso"
},
```


### Remove um grupo de acesso do sistema
### [DELETE /api/team/{grupo}]

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
