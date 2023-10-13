% Marcos Vinicius Firmino Pietrucci
% 10914211
% Assigment 4

%Reading the Traces
DataSet = csvread('Trace2.csv');
% DataSet = csvread('Trace2.csv');
% DataSet = csvread('Trace3.csv');

%Creating the DataSet
sDataSet = sort(DataSet);
N = length(sDataSet);
t = [0:600]; %for intervals

%Calculating the moments
Mean = sum(sDataSet)/N;
Moment2 = sum(sDataSet .^2)/N;
Moment3 = sum(sDataSet .^3)/N;
coef_var = std(sDataSet)/Mean;

%Fitting the uniform using direct expressions
left_boundary = Mean - sqrt(12*(Moment2 - Mean^2))/2;
right_boundary = Mean + sqrt(12*(Moment2 - Mean^2))/2;
figure(1)
plot(sDataSet, [1:N]/N, ".", t, Unif_cdf(t, [left_boundary, right_boundary]))
title('Uniform Distribution Trace1');
legend({'DataSet','Uniform Distribution'},'Location','southeast')
grid

%Fitting the Exponential using direct expressions
lambda = 1/Mean;
figure(2)
plot(sDataSet, [1:N]/N, ".", t, Exp_cdf(t, [lambda]))
legend({'DataSet','Exponential Distribution'},'Location','southeast')
title('Exponential Distribution Trace1');
grid

%Hypo-Exponential using MLE method
if coef_var < 1 %Only available if the Cv is less than 1
    lambda1 = 1/(0.3*Mean);
    lambda2 = 1/(0.7*Mean);
    parameters = mle(DataSet, 'pdf', @(DataSet, lambda1, lambda2)HypoExp_pdf(DataSet,[lambda1, lambda2]), ...
        'Start', [lambda1,lambda2]);
    figure(3)
    plot(sDataSet, [1:N]/N, ".", t, HypoExp_cdf(t, [parameters]))
    legend({'DataSet','Hypo Exponential'},'Location','southeast')
    title('Hypo Exponential Trace1');
    grid
end

%Hyper_Exponential using MLE method
if coef_var > 1 %Only available if the Cv is less than 1
    p1 = 0.4;
    lambda1 = 0.8/Mean;
    lambda2 = 1.2/Mean;
    parameters = mle(DataSet, 'pdf', @(DataSet, lambda1, lambda2, p1)HyperExp_pdf(DataSet,[lambda1, lambda2, p1]), ...
        'Start', [lambda1,lambda2, p1]);
    figure(4)
    plot(sDataSet, [1:N]/N, ".", t, HyperExp_cdf(t, [parameters]))
    legend({'DataSet','Hyper Exponential'},'Location','southeast')
    title('Hyper Exponential Trace1');
    grid
end


