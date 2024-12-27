-- TAREFA 4: Explicação sobre Exclusão Lógica

/*
    Da forma que a estrutura das tabelas foi modelada, a exclusão lógica foi aplicada diretamente na tabela enrollment no script da Tarefa 1.
    A coluna "deleted_at TIMESTAMP" foi adicionada permitindo que, ao invés de remover fisicamente um registro marcamos "deleted_at = NOW()" para indicar exclusão.
    Para exibir somente registros ativos, basta usar:

    WHERE deleted_at IS NULL

    em qualquer consulta de SELECT dessa forma o registro não é removido do banco e pode ser restaurado (set "deleted_at = NULL") ou efetivamente removido posteriormente.

    Como boa prática de performance, criamos um índice parcial (idx_enrollment_tenant_institution_not_deleted) que ajuda a filtrar rapidamente onde deleted_at IS NULL.

    Dessa forma no futuro poderiamos implantar um TTL para deixar a tabela mais leve utilizando esse campo como referência para remoção de registros antigos.
*/

