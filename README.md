# Sistema Mobile de Restaurante
Este projeto é um sistema para dispositivos móveis desenvolvido em Flutter com Dart. O ambiente de execução utilizado foi o Chrome, aproveitando o suporte do Flutter Web para facilitar testes rápidos e ajustes na interface.

## Persistência
A aplicação utiliza SharedPreferences como tecnologia de persistência permanente para o tema do aplicativo e para os dados do pedido, persistindo à atualização da guia ou fechamento do navegador.</br>
Para facilitar a manipulação dos dados estruturados, foram utilizados:
<ul>
<li>jsonEncode() → para serializar objetos em String</li>
<li>jsonDecode() → para transformar a String novamente em mapa/objeto utilizável</li>
</ul>
Essa combinação permite armazenar coleções complexas de dados de forma prática.

## Funcionalidades

O sistema implementa um CRUD completo, incluindo:
<ul>
<li>Create → cadastro de itens no cardápio e no carrinho</li>
<li>Read → listagem dinâmica dos itens salvos</li>
<li>Update → edição de produtos, quantidades e informações</li>
<li>Delete → remoção de registros preservados no SharedPreferences</li>
</ul>
Toda a lógica de persistência foi estruturada para garantir integridade dos dados entre sessões.

## Aplicativo em funcionamento

<img width="375" height="666" alt="image" src="https://github.com/user-attachments/assets/7589b86f-abb6-4cbe-99db-9a1526135f5c" />

### Realização de pedido

#### Seleção do prato
<img width="374" height="666" alt="image" src="https://github.com/user-attachments/assets/04e2cfb4-5585-4dd3-8355-fb04f1f4c9a1" /> </br>
<img width="376" height="670" alt="image" src="https://github.com/user-attachments/assets/e17df625-ae94-45a9-a35f-8d21561c3115" />

#### Entrada de dados
<img width="378" height="669" alt="image" src="https://github.com/user-attachments/assets/2ba6bc95-2569-453d-ad00-d910f4bd4911" /></br>
<img width="376" height="666" alt="image" src="https://github.com/user-attachments/assets/4ba1cd2c-39fc-4ed3-a56c-17ea173c8bff" />

#### Informações do pedido
<img width="377" height="670" alt="image" src="https://github.com/user-attachments/assets/1802945d-5d7a-4e2a-8b20-740619471600" />

### Alteração de pedido

#### Tela de pedidos
<img width="379" height="669" alt="image" src="https://github.com/user-attachments/assets/d86f64df-670b-4a4e-a94b-010d4f9336cd" />

#### Edição do pedido
<img width="379" height="669" alt="image" src="https://github.com/user-attachments/assets/97b2dac5-8eb1-4b73-8fbb-260063b221b2" />

#### Alteração realizada
<img width="376" height="667" alt="image" src="https://github.com/user-attachments/assets/8270dc53-acb0-4882-b7fc-2fc7e1b78e6e" />

### Cancelamento de pedido

#### Pedido 1
<img width="380" height="673" alt="image" src="https://github.com/user-attachments/assets/c995d53c-a6cc-4e64-861d-d3d98b2f5c16" /></br>
<img width="378" height="670" alt="image" src="https://github.com/user-attachments/assets/7999550c-7740-4468-bd71-813c223fef7a" />

#### Pedido 2
<img width="378" height="670" alt="image" src="https://github.com/user-attachments/assets/705d3e18-f2f5-4dea-a29f-c0652950de25" /></br>
<img width="380" height="671" alt="image" src="https://github.com/user-attachments/assets/0763d6d0-ff3b-4e3a-8fe4-e61f13af8add" />

### Modo escuro

#### Seleção do tema
<img width="376" height="668" alt="image" src="https://github.com/user-attachments/assets/f9ce1116-2cb3-42aa-bb8b-6b22915a661a" />
<img width="379" height="672" alt="image" src="https://github.com/user-attachments/assets/108dd673-662f-4266-b3aa-2b009074bee5" />

#### App com tema escuro
<img width="372" height="662" alt="image" src="https://github.com/user-attachments/assets/e60dbd21-ab8c-4781-ba33-a3ed44c595b6" />
<img width="369" height="661" alt="image" src="https://github.com/user-attachments/assets/1b9898b0-398a-4858-98b2-eaad9e285c52" />
<img width="373" height="666" alt="image" src="https://github.com/user-attachments/assets/682d12ec-adb0-412e-9bba-84588984fa95" />
<img width="370" height="663" alt="image" src="https://github.com/user-attachments/assets/e0fffc5a-6907-4dae-8ead-8488ccfaf315" />



