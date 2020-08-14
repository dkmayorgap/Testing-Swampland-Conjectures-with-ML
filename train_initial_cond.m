%In this program is made a clasification of the good cases in in strin
%theory to find zeros in some functions based on some masses
load ./train_input_rand_2.txt % 38000 random cases from the data based+
load ./initial_conditions.txt

train_output = initial_conditions(:,6)';
train_input = train_input_rand_2(1:max(size(train_output)),:)';

% index = find(train_output >1e-18);
% train_output = train_output(index);
% train_input = train_input(:,index);
in = 1;
m = 15;
n = 15;

NN1 = {};

perform = zeros(m,1);
rel_error = zeros(m,1);
for i=in:m
    %First hidden layer
    last_perf = 1e1000;
    disp(strcat('Number of Neurons = ',int2str(i)))
    for l = 1:n
        net1 = feedforwardnet(i,'trainlm');
        net1.divideParam.testRatio = 0.1;
        net1.divideParam.trainRatio = 0.8;
        net1.divideParam.valRatio = 0.1;
%         net1.trainParam.showWindow = 0; 
        net1 = train(net1,train_input,train_output);
        perf = mse(net1,train_output,net1(train_input));
        if perf < last_perf
            NN1{i} = net1;
            last_perf = perf;
            rel_error_l = 100*sum(abs((train_output - net1(train_input))/train_output))/max(size(train_output));
        end
    end
    perform(i) = last_perf;
    rel_error(i) = rel_error_l;
end

[best,ind] = min(perform);
net_best = NN1{ind};
output = net(train_input(:,1));
cond_6 = net;
% output_ones = find(output > 0.5);
% plotconfusion(train_output,net(train_input))
% load data_T.txt
% All_cases = net(data_T');
% good_cases = find(All_cases > 0.5);
% dlmwrite('initial_cond_ann.txt',initial_cond_ann);
save initial_cond_ann initial_cond_ann
% 
% load train_output_rand_2.txt
% load train_input_rand_2.txt
% 
% test_input = train_input_rand_2(22000:end,:)';
% test_output = train_output_rand_2(22000:end,:)';
% 
% res_test = net(test_input);
% plotconfusion(test_output,res_test)
% save net net