% Marcos Vinicius Firmino Pietrucci
% 10914211
% Assigment 4

%Reading the Traces
DataSet = csvread('Trace1.csv');
% DataSet = csvread('Trace2.csv');

%Creating the DataSet
sDataSet = sort(DataSet);
N = length(sDataSet);
t = [0:150]; %for intervals

%Calculating the moments
Mean = sum(sDataSet)/N;
Moment2 = sum(sDataSet .^2)/N;
Moment3 = sum(sDataSet .^3)/N;
coef_var = std(sDataSet)/Mean;

%Fitting the uniform using direct expressions
left_boundary = Mean - sqrt(12*(Moment2 - Mean^2))/2;
right_boundary = Mean + sqrt(12*(Moment2 - Mean^2))/2;

%Fitting the Exponential using direct expressions
exp_lambda = 1/Mean;

%Fitting the Erlang distribution
k = round(1/coef_var^2);
lambda_erlang = k/Mean;

%Fitting the Weibull
syms scale shape
eq1 = Mean == scale * gamma(1 + 1/shape); %Defiing first moment equation
eq2 = Moment2 == (scale^2) * gamma(1 + 2/shape); %Second moment
weibull_params = vpasolve([eq1, eq2], [scale, shape], [1,1]);
weib_scale = double(weibull_params.scale);
weib_shape = double(weibull_params.shape);

%Fitting the Pareto
syms alpha m
eq3 = Mean == (alpha * m) / (alpha - 1); %Equations from slides
eq4 = Moment2 == (alpha * m^2)/(alpha-2);
pareto_params = solve([eq3, eq4], [alpha, m]);
alpha_pareto = double(pareto_params.alpha(1));
m_pareto = double(pareto_params.m(1));

%Hypo-Exponential using MLE method
lambda1 = 1/(0.3*Mean);
lambda2 = 1/(0.7*Mean);
hypo_parameters = mle(DataSet, 'pdf', @(DataSet, lambda1, lambda2)HypoExp_pdf(DataSet,[lambda1, lambda2]), ...
  'Start', [lambda1,lambda2]);

%Hyper_Exponential using MLE method
p1 = 0.4;
lambda1 = 0.8/Mean;
lambda2 = 1.2/Mean;
hyper_parameters = mle(DataSet, 'pdf', @(DataSet, lambda1, lambda2, p1)HyperExp_pdf(DataSet,[lambda1, lambda2, p1]), ...
    'Start', [lambda1,lambda2, p1]);

%%%%%%%%%%%%%%% PLOTING RESULTS %%%%%%%%%%%%%%%

%Checking fro the existance of hypo exponential
if coef_var < 1 %Only available if the Cv is less than 1
    figure(1)
    plot(sDataSet, [1:N]/N, ".", t, Unif_cdf(t, [left_boundary, right_boundary]), ...
        t, Exp_cdf(t, [exp_lambda]), ...
        t, gamcdf(t,k, 1/lambda_erlang), ...
        t, wblcdf(t, weib_scale, weib_shape), ...
        t, HypoExp_cdf(t, [hypo_parameters]), ...
        t, Pareto_cdf(t, [alpha_pareto, m_pareto]))
    legend({'DataSet','Uniform', 'Exponential','Erlang', 'Weibull', 'HypoExponential', 'Pareto'},'Location','southeast')
    title('CDF distributions Trace 1');
    grid
end

%Checking for existance of HyperExponential
if coef_var > 1 %Only available if the Cv is less than 1
    figure(1)
    plot(sDataSet, [1:N]/N, ".", t, Unif_cdf(t, [left_boundary, right_boundary]), ...
        t, Exp_cdf(t, [exp_lambda]), ...
        t, gamcdf(t, k, 1/lambda_erlang), ...
        t, wblcdf(t, 5.75773, 2.12057), ...
        t, HyperExp_cdf(t, [hyper_parameters]), ...
        t, Pareto_cdf(t, [alpha_pareto, m_pareto]))
        
    legend({'DataSet','Uniform', 'Exponential','Erlang', 'Weibull', 'HyperExponential', 'Pareto'},'Location','southeast')
    title('CDF distributions Trace 2');
    grid
end


function F = Pareto_cdf(x, p)
	alpha = p(1); %alpha value (shape)
	m = p(2); %m value (scale)
    
    i = 1;
    while i ~= length(x)  + 1
        if(x(i) >= m)
	        F(i) = 1 - (m/x(i))^alpha;
        else
            F(i) = 0;
        end
        i = i+1;
    end
end
