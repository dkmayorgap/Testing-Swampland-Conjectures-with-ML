%In this program is made a clasification of the good cases in in strin
%theory to find zeros in some functions based on some masses
load ./data_input.txt 
load ./data_output.txt % first 10000 cases from the data based
load ./train_input_rand_2.txt 
load ./train_output_rand_2.txt % 38000 random cases from the data based+
load ./Data/good_cases_T.txt
% load ./Data/Data_Good_in_T.txt
% load ./Data/Data_Good_out_T.txt

good_cases_output = ones(max(size(good_cases_T)),1);

train_input = [data_input;train_input_rand_2;good_cases_T]';
train_output = [data_output;train_output_rand_2;good_cases_output]';
% train_input = Data_Good_in_T';
% train_output = Data_Good_out_T';
% train_input = [data_input;train_input_rand_2]';
% train_output = [data_output;train_output_rand_2]';

ind_1 = find(train_output >0);
ind_0 = find(train_output == 0);
train_in_1 = train_input(:,ind_1);
train_in_0 = train_input(:,ind_0);
train_out_1 = train_output(:,ind_1);
train_out_0 = train_output(:,ind_0);
rand_per = randperm(max(size(train_out_0)),30000);
train_out_0 = train_out_0(:,rand_per);
train_in_0 = train_in_0(:,rand_per);
train_input = [train_in_0,train_in_1];
train_output = [train_out_0,train_out_1];

in = 1;
m = 35;
n = 10;

NN1 = {m};

perform = zeros(m,1);
for i=in:m
    %First hidden layer
    last_perf = 1000;
    disp(strcat('Number of Neurons = ',int2str(i)))
    for l = 1:n
        net1 = patternnet(i,'trainlm');
        net1.divideParam.testRatio = 0.1;
        net1.divideParam.trainRatio = 0.8;
        net1.divideParam.valRatio = 0.1;
%         net1.trainParam.showWindow = 0; 
        net1 = train(net1,train_input,train_output);
        perf = crossentropy(net1,train_output,net1(train_input));
        if perf < last_perf
            NN1{i} = net1;
            last_perf = perf;
        end
    end
    perform(i) = last_perf;
end

[best,ind] = min(perform);
net = NN1{ind};
output = net(train_input);
output_ones = find(output > 0.5);
plotconfusion(train_output,net(train_input))
% load data_T.txt
All_cases = net(data_T');
good_cases = find(All_cases > 0.5);

[val,pos] = intersect(good_cases,good_cases_improved);

% dlmwrite('good_cases_T.txt',good_cases);
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