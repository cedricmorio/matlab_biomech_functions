function [p05,sd,stats] = probit(x,y,trace,s)
% [p05,sd,stats] = probit(x,y,trace,s)
% modélisation de la variable y en fonction de la variable x selon une loi
% probit définie sur [0 1]
% écrit par Cédric Morio, Decathlon SportsLab, 2016
% 
% inputs :
%     x, variable indépendante
%     y, variable dépendante définie sur [0 1]
%     trace = 0, n'enregistre pas le graphique de résultat
%     s, le nom de la figure sujet+condition
% outputs :
%     p05, la moyenne de la gaussienne, la valeur de la probit à 0,5
%     sd, l'écart-type de la gaussienne
%     stats, l'ensemble des résultats statistique associés à la probit
    if nargin < 3
        trace = 0;
    elseif nargin < 4
        if isnumeric(trace)
            s = '0';
        elseif ischar(trace)
            s = trace;
            trace = 1;
        end
    end
    [b,dev,stats] = glmfit(x,y,'binomial','probit');
    p05 = -b(1)/b(2);
    sd = 1/b(2);
    
    % vérification graphique
    if trace
        f = figure;
        new = (0.3:0.05:1.3)';
        [yfit,dlo,dhi] = glmval(b,new,'probit',stats,0,1);
        errorbar(new,yfit,dlo,dhi);
        hold on
        plot(x,y,'or');
        saveas(f,['probit' s '.fig']);
        saveas(f,['probit' s '.png']);
        close(f);
    end
end