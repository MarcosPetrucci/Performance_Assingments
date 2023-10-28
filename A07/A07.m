% Marcos Vinicius Firmino Pietrucci
% 10914211
% Assigment 5

clear all;

s = 1;
t = 0;

Tmax = 1000000;

trace = [t, s];

Tentrance = 0;
Tlava = 0; %s = 5
Tc1 = 0; %s = 2
Tc2 = 0; %s= 3
Texit = 0; %s = 4

roundTripTime = 0;
RTT = [];
roundIndex = 1;

while t < Tmax
    if s == 1
        if rand() < 0.3 %going to c2
            %Computar aqui a chance de cair
            if rand() < 0.3 %Reached C2
                %Time uniform a=3 b=6
                ns = 3;
            else %Will fall
                %Time exp = 0.25
                ns = 5;
            end
        else %going to c1
            %Computar aqui a chance de cair
            if rand() <= 0.2
                %Will fall with exp 0.5
                ns = 5; %Lava
            else
                %will not fall and reach C1 in Erlang k=4 lambd =1.5
                ns = 2; %C1
            end
        end
    end

    if s == 2 %C1 successfully reached     
        if rand() < 0.50
            %Will continue on yellow to C2
            if rand () < 025
                %Was successfull, reached C2
                %Erlang k=3 lambd =2
                ns = 3;
            else
                %Was not successfull
                %Exponential 0.4
            end
        else
            %Will go to C2 via white
            if rand() < 0.6
                %Was successfull!
                %Exp = 0.15
                ns = 3;
            else
                %Fell in the lava
                %exp lambd = 0.2
                ns = 5;
            end
        end		
    end
    
    %In C2
    if s == 3
        %Will try to go to the exit
        %Both cases have Erlang k= 5 lambd = 4
        if rand() < 0.6
            %Success
            ns = 4;
        else
            %Fell in lava
            ns = 5;
        end
    end
    
    %Reached the end! Need 5min to reset the room
    if s == 4
        dt = 60*5;
    end
    
    %Fell in Lava... Need 5min to reset the rooms
    if s == 5
        dt = 60*5;
    end

    s = ns;
	t = t + dt;
	trace(end + 1, :) = [t, s];

end

Ps1 = Tc1 / t
Ps2 = Tc2 / t
Ps3 = Texit / t



