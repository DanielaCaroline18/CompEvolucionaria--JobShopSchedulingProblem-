function [makespan, sequence, avg_fit, best_fit] = JSSP(arquivo)
A=load(arquivo);%arquivo de entrada
nC=size(A, 2);%n�mero de maquinas
nL=size(A, 1);%n�mero de pedidos
%tamanho da popula��o
Tpop =20;

%probabilidade de cruzamento
pcruz=0.9;

%probabilidade de muta��o
pmut=0.9;

%n�mero de gera��es
Nger=200;

best_fit=zeros(1, Nger);
avg_fit=zeros(1, Nger);

%inicializa popula��o
pop=zeros(Tpop, nL);
for i=1:Tpop
    pop(i, :)=randperm(nL);
end

%---Para primeria popula��o gerada--------
%escolha aleatoriamente dez indiv�duos na popula��o;
r=5;
k = ceil(rand(1, r)*Tpop);
ind_aleatorio = pop (k, :);
paisinit = [1:nL; 1:nL];

int=1;
while(1)
    %----- Fitness------------------------
    fit= fitness(pop,A, nC, nL);
    
    %------makespan m�dio (fitness m�dio)-----------------
    avg_fit(int) = mean(fit);
    
    %---------melhor makespan (melhor fitness)---------------
    best_fit(int) = min(fit);
    
    %-----indice do melhor fitness atual-----------
    indice = find(fit==min(fit));
    
    %----sequencia do melhor makespan----------
    sequence = pop(indice(1), :);    
    
    %-------Sele��o dos Pais----------------
    pais = SelecionaPais(paisinit,ind_aleatorio, r, A, nL, nC);
    
    %---------Crossover----------------------
    filhos = Cruzamento(pais, pcruz);
    
    %--------Muta��o-----------------------
    novosfilhos = Mutacao(filhos, pmut);
    
    %----------Sele��o dos sobreviventes----------
    pop = SelecionaSobrevivente (pop, novosfilhos,A, nL, nC);
    
    %-----------Seleciona individuos aleatorios que podem ser pais-----
    k = ceil(rand(1, r)*Tpop);
    ind_aleatorio = pop (k, :);
    
    
    if ((int > Nger))
        break;
    end
    int=int+1;
end
%fitness da melhor solu��o encontrada
makespan=min(best_fit);

figure(1)
hold on
plot(avg_fit,'r*-')
plot(best_fit,'b*-')
xlabel('gera��o')
ylabel('fitness')
title('\fontsize{16}Desempenho')
legend('media', 'melhor')
xlim([0 Nger])

end