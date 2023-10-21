# API RESTful de sebo online
API RESTful que fornece cadastro de usuários, livros e transações.

## Pré-requisitos
* SBCL (Steel Bank Common Lisp)
* Quicklisp
  
## Link da aplicação
http://vps49843.publiccloud.com.br:5000

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
        + Authorization: {token}
+ Response 200 (application/json)
    + Body
```
{
    "id":1,
    "name":"felipe",
    "email":"seller@seller.com",
    "status":"ativo",
    "kind":"seller",
}
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
    "id":1,
    "name":"felipe",
    "email":"seller@seller.com",
    "status":"ativo",
    "kind":"seller"
}
```

### Retorna um token com poder de usuário normal
### [POST /user/login]
+ Request (application/json)
    + Body
        + Parameters
            + email - *e-mail do usuário*
            + password - *senha do usuário*
+ Response 200 (application/json)
    + Body
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwia2luZCI6InNlbGxlciJ9.cMNAieYJiZgOewKulhyoIqUiikhnrhjz6mr8LpRVdHo
```
## PUT endpoints

### Edita o perfil do usuário
### [PUT /user/{id}]
+ Request (application/json)
    + Headers
        + Authorization: {token}
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

}
```

## DELETE endpoints

### Remove um usuário do sistema
### [DELETE /user/{id}]

+ Request (application/json)
    + Headers
        + Authorization: {token}
+ Response 200 (application/json)
    + Body
```
{

}
```
# Administrador

## GET endpoints

### Retorna todos os usuários cadastrados n
### [GET /admin/users]

+ Request (application/json)
    + Headers
        + Authorization: {token}
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
### [POST /admin/login"]
+ Parameters
    + email - *e-mail do administrador*
    + password - *senha do administrador*
+ Request (application/json)

+ Response 200 (application/json)
    + Body
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwia2luZCI6InNlbGxlciJ9.cMNAieYJiZgOewKulhyoIqUiikhnrhjz6mr8LpRVdHo
```
