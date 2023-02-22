N=21140;      % size of the Monte Carlo simulation with alpha = 0.02 and error = 0.008
binom_n = 250; 
binom_p = 0.62; % Number of chunks produced in 5 days is a Binomial random variable with 5n so n=5*50 and p = 0.62.
TotalWeight=zeros(N,1); % a vector that keeps the total weight of the plastics produced for each Monte Carlo run
for k=1:N;
		% first generate sample Y, the number of plastic chunks produced in 5 days using sampling from Binomial
	U = rand(binom_n,1); 
        Y = sum(U < binom_p);  % Y is the number of plastic chunks produced
	weight = 0; % total weight of plastic chunk for this run
	
	% now sample Y plastic chunks weights using rejection sampling
	s = 0; t = 8; m = 0.22;  % the boundary of the rejection sampling rectangle
	for f=1:Y; 
		CX = 0; CY = m; % initial coordinates for rejection sampling
		f = 0; % initial f at CX = 0
		while (CY > f); 
			U = rand; V = rand;   
			CX = s+(t-s)*U; CY = m*V;
			
			if CX <= 2
				f = 0.07*(CX);
			elseif CX <=5
				f = -0.02*((CX-4)^2) + 0.22;
      elseif CX <=7
				f = 0.08*(5-CX) + 0.2;
			else
				f = -0.04*(CX)+ 0.32;
			end
		end;
		weight = weight + CX;	
	end;
	TotalWeight(k) = weight;
end;
p_est = mean(TotalWeight>640); 
expectedWeight = mean(TotalWeight);
stdWeight = std(TotalWeight);
fprintf('Estimated probability = %f\n',p_est);
fprintf('Expected weight = %f\n',expectedWeight);
fprintf('Standard deviation = %f\n',stdWeight);