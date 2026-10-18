# Especificação para o brModelo

## DER (modelo conceitual)

**Entidades e atributos**
- PROPRIETARIO: **cpf**, nome, endereco, bairro, cidade, estado, sexo, data_nascimento, idade (*derivado*), telefones (*multivalorado*)
- VEICULO: **placa**, chassi, cor_predominante, ano_fabricacao
- MODELO: **codigo_modelo** (6 dígitos), descricao
- CATEGORIA: **codigo_categoria** (2 dígitos), descricao
- TIPO_INFRACAO: **codigo_tipo** (inteiro), descricao, valor
- LOCAL: **latitude + longitude** (identificador composto), velocidade_permitida (opcional)
- AGENTE: **matricula**, nome, data_contratacao, tempo_servico_meses (*derivado*)
- INFRACAO (entidade associativa/ternária de VEICULO x TIPO_INFRACAO): data_hora, velocidade_afetada (opcional)

**Relacionamentos (cardinalidades)**
- PROPRIETARIO (1,1) — possui — (0,N) VEICULO
- MODELO (1,1) — classifica — (0,N) VEICULO
- CATEGORIA (1,1) — enquadra — (0,N) VEICULO
- VEICULO (0,N) — comete — (1,1) INFRACAO
- TIPO_INFRACAO (1,1) — tipifica — (0,N) INFRACAO
- LOCAL (1,1) — ocorre em — (0,N) INFRACAO
- AGENTE (1,1) — registra — (0,N) INFRACAO

## DLD (modelo lógico)

PROPRIETARIO(**cpf**, nome, endereco, bairro, cidade, estado, sexo, data_nascimento)
TELEFONE_PROPRIETARIO(**id_telefone**, telefone, *cpf* → PROPRIETARIO)
MODELO(**codigo_modelo**, descricao)
CATEGORIA(**codigo_categoria**, descricao)
VEICULO(**placa**, chassi, cor_predominante, ano_fabricacao, *codigo_modelo* → MODELO, *codigo_categoria* → CATEGORIA, *cpf_proprietario* → PROPRIETARIO)
TIPO_INFRACAO(**codigo_tipo**, descricao, valor)
LOCAL_INFRACAO(**latitude, longitude**, velocidade_permitida)
AGENTE(**matricula**, nome, data_contratacao)
INFRACAO(**id_infracao**, *placa* → VEICULO, data_hora, *codigo_tipo* → TIPO_INFRACAO, *latitude, longitude* → LOCAL_INFRACAO, velocidade_afetada, *matricula_agente* → AGENTE)

Atributos derivados (idade e tempo de serviço) não são armazenados: são calculados nas consultas/views.
