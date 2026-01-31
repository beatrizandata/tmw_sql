SELECT idCliente,
        -- QtdePontos + 10 AS QtdePontosPlus10, -- isso não cria nada novo no db
        -- QtdePontos * 2 AS QtdePontosDouble,
        DtCriacao,
        datetime(substr(DtCriacao, 1, 19)) AS DataHora,
        strftime('%w', datetime(substr(DtCriacao, 1, 10))) AS DiaSemana
FROM clientes