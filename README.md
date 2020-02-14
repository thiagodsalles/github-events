# Bem vindo ao GitHub Events

## Instalação

### Alterando as senhas padrões e os secrets

Dentro do projeto rode o seguinte comando no bash para abrir o arquivo com as senhas  e secrets `EDITOR=nano rails credentials:edit`

O arquivo vem no seguinte formato:

    # usuário e senha para o get
    get_token:
	    username: <seu username>
	    password: <sua senha>
	    
	# secret inserido no github    
    github_secret:
	    sercret: <github secret>

## Como funciona

Com as devidas configurações feitas, o webhook do GitHub irá disparar o evento para sua aplicação e assim salvando no banco de dados. Ela utilizará a seguinte requisição:

    POST  /issues/events

Para verificar os eventos criados você deverá utilizar a seguinte requisição:

    GET  /issues/:number/events

Neste caso você irá passar o number da issue e ele retornará todos os eventos dessa issue, lembrando que esta requisição precisará do usuário e senha definidos anteriormente.

## Gems instaladas

- Rspec