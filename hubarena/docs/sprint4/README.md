# HubArena -- Sprint 4

## Laboratório de Desenvolvimento de Aplicações Móveis e Distribídas

A Sprint 4 representa a etapa final do desenvolvimento do HubArena,
consolidando todas as funcionalidades implementadas nas sprints
anteriores e integrando completamente os componentes da aplicação
distribuída. Nesta fase foram concluídos o aplicativo Flutter destinado
ao prestador de serviços, a integração entre os aplicativos de cliente e
prestador, o backend REST, o banco de dados PostgreSQL e o middleware
RabbitMQ, permitindo a execução do fluxo completo proposto pela
disciplina.

A estrutura desta entrega está organizada da seguinte forma:

``` text
docs/
└── sprint4/
    ├── README.md
    ├── relatorio/
    │   └── Relatorio_Tecnico_Final.docx
    └── video/
        └── screencast.mp4
```

Para executar o projeto é necessário possuir Python 3.12 ou superior,
Flutter SDK, Android Studio, PostgreSQL, RabbitMQ, Docker Desktop, Git e
Git Bash devidamente instalados e configurados.

O primeiro passo consiste em iniciar o backend da aplicação. A partir da
pasta `backend`, deve-se ativar o ambiente virtual, iniciar os serviços
do PostgreSQL e RabbitMQ e executar a API Flask.

``` bash
cd backend
source .venv/Scripts/activate
docker compose up -d
python init_db.py
python run.py
```

Caso os containers já existam, basta inicializá-los utilizando:

``` bash
docker start hubarena-postgres hubarena-rabbitmq
```

Após a inicialização, a API estará disponível em:

``` text
http://127.0.0.1:5000
```

Em seguida, deve-se iniciar o consumidor de mensagens do RabbitMQ em um
segundo terminal.

``` bash
cd backend
source .venv/Scripts/activate
python -m app.messaging.reservation_consumer
```

O consumidor deverá permanecer em execução durante toda a demonstração
para que os eventos publicados pelo backend sejam processados
corretamente.

Com o backend em funcionamento, o próximo passo consiste em executar o
aplicativo Flutter.

``` bash
cd mobile/hubarena_app
flutter pub get

flutter run -d emulator-5554 \
--dart-define=API_BASE_URL=http://10.0.2.2:5000 \
--dart-define=CLIENT_ID=2 \
--dart-define=PROVIDER_ID=1
```

Durante a validação da Sprint 4 recomenda-se seguir o fluxo completo da
aplicação. Inicialmente o prestador realiza o login e cadastra uma arena
esportiva. Em seguida é criada uma quadra vinculada à arena.
Posteriormente o cliente realiza o login, pesquisa uma arena, seleciona
uma quadra disponível e cria uma solicitação de reserva.

Após a criação da reserva, o backend registra a solicitação no banco de
dados e publica automaticamente um evento no RabbitMQ. O aplicativo do
prestador recebe essa atualização de forma assíncrona, sem necessidade
de atualização manual da interface, permitindo ao prestador aceitar ou
recusar a solicitação. Após a alteração do status da reserva, o cliente
acompanha automaticamente a atualização e pode consultar o histórico das
reservas realizadas.

Antes da demonstração final recomenda-se executar os testes
automatizados do aplicativo Flutter.

``` bash
dart format lib test
flutter analyze
flutter test
```

Todos os testes devem ser concluídos sem erros. Também é recomendável
validar o funcionamento da API por meio dos endpoints de monitoramento,
verificando a disponibilidade do backend, da conexão com o PostgreSQL e
da comunicação com o RabbitMQ.

O vídeo de demonstração da Sprint 4 encontra-se disponível em:

``` text
docs/sprint4/video/screencast.mp4
```

O relatório técnico final encontra-se disponível em:

``` text
docs/sprint4/relatorio/Relatorio_Tecnico_Final.docx
```

Nesse documento são descritas a arquitetura implementada, as decisões de
projeto, as dificuldades encontradas durante o desenvolvimento, as
soluções adotadas e a aplicação dos conceitos estudados ao longo da
disciplina, incluindo REST, Message-Oriented Middleware (MOM),
Event-Driven Architecture (EDA) e Clean Architecture.

Ao concluir todas as etapas descritas neste documento será possível
validar integralmente o funcionamento da Sprint 4, demonstrando a
integração entre os aplicativos Flutter, o backend REST, o PostgreSQL e
o RabbitMQ no fluxo completo de criação, processamento e conclusão de
reservas esportivas.