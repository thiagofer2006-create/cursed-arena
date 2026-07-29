# Cursed Arena - Arquitetura

## Objetivo

Construir um jogo de combate no Roblox com arquitetura modular, escalável e fácil de manter.

O projeto prioriza organização, desacoplamento e evolução incremental.

---

# Princípios

## 1. Uma responsabilidade por módulo

Cada módulo deve possuir apenas uma responsabilidade.

Exemplos:

- InputController → recebe inputs.
- SprintController → controla sprint.
- PunchController → controla socos.
- MovementController → altera velocidade do personagem.

Nenhum módulo deve assumir responsabilidades de outro.

---

## 2. Comunicação por sinais

Os módulos não conversam diretamente.

Toda comunicação acontece através do arquivo:

src/client/Signals.lua

Exemplo:

InputController
        ↓
Signals.PunchRequested
        ↓
PunchController

Isso reduz dependências e facilita testes.

---

## 3. Main.client.lua

O Main.client.lua nunca possui lógica de gameplay.

Sua única responsabilidade é inicializar os controllers.

---

## 4. Input

O InputController apenas transforma teclado, mouse ou gamepad em eventos.

Ele nunca executa ações diretamente.

Exemplo:

ERRADO

Mouse
↓
Dano

CERTO

Mouse
↓
PunchRequested
↓
PunchController

---

## 5. Controllers

Cada sistema possui seu próprio controller.

Exemplos:

SprintController

PunchController

MovementController

AnimationController

CombatController

Cada controller deve ser pequeno e possuir apenas uma responsabilidade.

---

## 6. Config

Todos os valores configuráveis ficam em Config.lua.

Nunca utilizar números mágicos.

Exemplo:

SprintSpeed

WalkSpeed

PunchCooldown

DashDistance

---

## 7. Desenvolvimento incremental

Cada funcionalidade será construída em pequenas etapas.

Exemplo:

Sprint

Input

Movimento

Teste

Commit

Punch

Input

Controller

Teste

Commit

Combo

Controller

Teste

Commit

Nenhum sistema será implementado inteiro de uma vez.

---

## 8. Cliente e Servidor

Cliente:

Input

Animações

Interface

Efeitos

Servidor:

Dano

Hitbox

Validação

Estado do combate

Nunca confiar no cliente para causar dano.

---

## Objetivo Final

Criar uma base sólida que permita adicionar novos personagens, habilidades e sistemas sem necessidade de reescrever código existente.