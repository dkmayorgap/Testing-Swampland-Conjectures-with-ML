% Net to determine if the two constants Lambda and m^2 are positive

%In this program is made a clasification of the good cases in in strin
%theory to find zeros in some functions based on some masses
load ./Data/ds_i.txt % columns 1-m^2 2-Lambda
load ./Data/ds_o.txt 
load ./Data/jer_i.txt 
load ./Data/jer_o.txt 
load ./Data/noT_i.txt
load ./Data/noT_o.txt
load ./train_input_rand_2.txt 
load ./train_output_rand_2.txt % 38000 random cases from the data based+

noTorLambda = 2; % if not_Taquiones opt 1 if Lambda opt 2


train_input = [ds_i;jer_i;noT_i]';
train_output = [ds_o(:,noTorLambda);jer_o(:,noTorLambda);noT_o(:,noTorLambda)]';
train_output = train_output>0;
% train_input = Data_Good_in_T';
% train_output = Data_Good_out_T';
% train_input = [data_input;gthttrain_input_rand_2]';
% train_output = [data_output;train_output_rand_2]';

% ind_1 = find(train_output >0);
ind_0 = find(train_output_rand_2 == 0);
% train_in_1 = train_input(:,ind_1);
train_in_0 = train_input_rand_2(ind_0,:)';
% train_out_1 = train_output(:,ind_1);
train_out_0 = train_output_rand_2(ind_0,:)';
% rand_per = randperm(max(size(train_out_0)),30000);
% train_out_0 = train_out_0(:,rand_per);
% train_in_0 = train_in_0(:,rand_per);
% train_input = [train_in_0,train_in_1];
% train_output = [train_out_0,train_out_1];
train_input = [train_input,train_in_0];
train_output = [train_output,train_out_0];

in = 1;
m = 25;
n = 10;

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
        net1.trainParam.showWindow = 0; 
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
output = net_best(train_input(:,1));
plotconfusion(train_output,net_best(train_input))
if noTorLambda == 1
    net_noT = net_best;
    save ./Data/nets/net_noT.mat net_noT
elseif noTorLambda == 2
    net_Lambda = net_best;
    save ./Data/nets/net_Lambda.mat net_Lambda
end



load ./Data/jerarquiaMUMSOK1.mat
cases_noT_jerarquiaMUMSOK1 = find(net_noT(jerarquiaMUMSOK1')>0.5);
cases_Lam_noT_jerarquiaMUMSOK1 = find(net_noT(jerarquiaMUMSOK1') >0.5 & net_Lambda(jerarquiaMUMSOK1')>0.5);
save ./Data/cases_noT_jerarquiaMUMSOK1.mat cases_noT_jerarquiaMUMSOK1
save ./Data/cases_Lam_noT_jerarquiaMUMSOK1.mat cases_Lam_noT_jerarquiaMUMSOK1
%Evaluate both lists MSOK and MUOK
% load ./Data/msok_in.txt
% load ./Data/muok_in.txt
% 
% cases_noT_muok = find(net_noT(muok_in')>0.5);
% cases_noT_msok = find(net_noT(msok_in')>0.5);
% 
% cases_Lam_noT_muok = find(net_noT(muok_in') >0.5 & net_Lam(muok_in')>0.5);
% cases_Lam_noT_msok = find(net_noT(msok_in') >0.5 & net_Lam(msok_in')>0.5);

