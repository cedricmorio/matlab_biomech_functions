function [odds] = oddsratio(De,He,Dn,Hn)
% oddsratio computed the odds ratio
% written by Cédric Morio, Decathlon SportsLab, June-September 2017
% [odds] = oddsratio(De,He,Dn,Hn)
%
%   inputs:
%       De is the disabled exposed population
%       He is the healthy exposed population
%       Dn is the disabled non-exposed population
%       Hn is the healthy non-exposed population
%   outputs:
%       odds is a structure of results
%           .RR is the relative risk (or risk ratio)
%           .OR is the odds ratio
%           .ORmoins is the lower interval of confidence
%           .ORplus is the upper interval of confidence
%           .RA is the attributable risk
%           .PA is the attributable part
%           .Z is the Z statistics of t-test compared to 1+/-0
%           .h0reject is the validation of Z statistics
%           .Khi2 is the X² statistics for 1 degre of freedom
%           .h0rejectkhi2 is the validation of the X² statistics
%
Ne = De + He;
Nn = Dn + Hn;
N = Ne + Nn;
odds.RR  = (De/Ne)/(Dn/Nn); % relative risk ratio
odds.OR  = (De/He)/(Dn/Hn); % odds ratio
logOR = log(odds.OR);
SE = sqrt(1/De+1/He+1/Dn+1/Hn); % standard error
odds.ORmoins = exp(logOR-1.96*SE); % borne inférieure de OR
odds.ORplus = exp(logOR+1.96*SE); % borne supérieure de OR
% fraction étiologique
odds.FE = ((De / Ne) - (Dn / Nn)) / (De / Ne);
% risque attribuable
pe = Ne/N;
odds.RA = (pe*(odds.RR-1))/(1+pe*(odds.RR-1));
% test du Khi²
%odds.Khi2 = ((De-((De+Dn)*(Ne/(Ne+Nn))))^2)/((De+Dn)*(Ne/(Ne+Nn))) + ((Dn-((De+Dn)*(Nn/(Ne+Nn))))^2)/((De+Dn)*(Nn/(Ne+Nn))) + ((He-((He+Hn)*(He/(Ne+Nn))))^2)/((He+Hn)*(He/(Ne+Nn))) + ((Hn-((He+Hn)*(Hn/(Ne+Nn))))^2)/((He+Hn)*(Hn/(Ne+Nn)));
%odds.Khi2 = ((De*Hn - He*Dn)^2*N) / ((De+He)*(Dn+Hn)*(De+Dn)*(He+Hn));
odds.Khi2 = N*((De^2/((De+Dn)*(De+He)))+(Dn^2/((De+Dn)*(Dn+Hn)))+(He^2/((He+Hn)*(De+He)))+(Hn^2/((He+Hn)*(Hn+Dn)))-1);
odds.h0rejectkhi2 = (odds.Khi2 > 3.841); % seuil Khi2 à p0.95 pour un ddl de 1
