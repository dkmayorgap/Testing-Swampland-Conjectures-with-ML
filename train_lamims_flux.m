load ./Data/good_0.txt
load ./Data/good_1.txt
load ./Data/random_0.txt
load ./Data/random_1.txt
load ./Data/random_flux.txt

input_random_0 = random_flux(random_0(:,1),:);
input_random_1 = random_flux(random_1(:,1),:);

cases_random_0 = 400;
input_random = [input_random_0(1:cases_random_0,:);input_random_1]';
output_random = [zeros(cases_random_0,1);ones(max(size(input_random_1)),1)]';

input_good_0 = data_T(good_0(:,1),:);
input_good_1 = data_T(good_1(:,1),:);

cases_good_0 = 400;
index = randperm(max(size(good_0)),cases_good_0);
input_good = [input_good_0(index,:);input_good_1]';
output_good = [zeros(cases_good_0,1);ones(max(size(good_1)),1)]';

index_all = 1:max(size(random_flux));
diff = setdiff(index_all,random_0(:,1)');
diff = setdiff(diff,random_1(:,1)');

cases_random_diff = 1600;
index_diff = randperm(max(size(diff)),cases_random_diff);
input_diff = random_flux(index_diff,:)';
output_diff = zeros(cases_random_diff,1)';

train_input = [input_random,input_good,input_diff];
train_output = [output_random,output_good,output_diff];

input_1 = [input_random_1;input_good_1]';
output_1 = ones(max(size(input_random_1)) + max(size(input_good_1)),1)';


in = 1;
m = 30;
n = 20;

NN1 = {};

perform = zeros(m,1);
rel_error = zeros(m,1);
for i=in:m
    %First hidden layer
    last_perf = 1000;
    disp(strcat('Number of Neurons = ',int2str(i)))
    for l = 1:n
        net = patternnet(i,'trainlm');
        net.divideParam.testRatio = 0.1;
        net.divideParam.trainRatio = 0.8;
        net.divideParam.valRatio = 0.1;
%         net1.trainParam.showWindow = 0; 
        net = train(net,train_input,train_output);
        perf = mse(net,output_1,net(input_1));
%         perf = mse(net,train_output,net(train_input));
        if perf < last_perf
            NN1{i} = net;
            last_perf = perf;
            rel_error_l = 100*sum(abs((train_output - net(train_input))/train_output))/max(size(train_output));
        end
    end
    perform(i) = last_perf;
    rel_error(i) = rel_error_l;
end

[best,ind] = min(perform);
net = NN1{ind};
output = net(train_input);
output_ones = find(output > 0.5);
plotconfusion(train_output,net(train_input))
all_cases = net(data_T');
Lambda_ims_goodCases = find(all_cases > 0.5);

net_lambda_ims = net;
save net_lambda_ims net_lambda_ims
save lambda_ims_good Lambda_ims_goodCases