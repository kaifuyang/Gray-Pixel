function [men,med,trimean,bst25,wst25] = evaluate(errors)

errors = sort(errors);
f05 = errors(floor(0.5*length(errors)));
f025 = errors(floor(0.25*length(errors)));
f075 = errors(floor(0.75*length(errors)));

med = median(errors);
men = mean(errors);
trimean = 0.25*(f025+2*f05+f075);
bst25 = mean(errors(1:floor(0.25*length(errors))));
wst25 = mean(errors(floor(0.75*length(errors)):end));


