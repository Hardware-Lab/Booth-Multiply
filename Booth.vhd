library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity booth is
Port(
M : in std_logic_vector(3 downto 0);
Q : in std_logic_vector(3 downto 0);
Q_out : out std_logic_vector(7 downto 0);
clk : in std_logic
);
end entity booth;

architecture Behavioral of booth is
	type state_t is (initial_state,initial_state_3, initial_state_2,check_q_0_and_q_0,state_10,state_01,shift_right,check_count,final_state);
	signal state : state_t := initial_state;
	signal next_state : state_t := check_q_0_and_q_0;
	signal Q_1 : std_logic_vector(0 downto 0);
	signal A : std_logic_vector(3 downto 0);
	signal Count : std_logic_vector(3 downto 0);
	signal M_temp : std_logic_vector(3 downto 0) ;
	signal M_temp_complement : std_logic_vector(3 downto 0) ;
	signal Q_temp : std_logic_vector(3 downto 0) ;
	signal temp : std_logic_vector(3 downto 0) ;


begin
		CMB : process(state)
			begin
				case state is
					when initial_state =>
						
						Q_1 <= "0";
						A <= "0000";
						Count <= "0011";
						next_state <= initial_state_2;
						
					when initial_state_2 =>
						M_temp <= M;
						Q_temp <= Q;
						temp <= not M;
						M_temp_complement <= std_logic_vector(unsigned(temp) + "0001");
						
						
						next_state <= initial_state_3;
						
					when initial_state_3 => 
						M_temp_complement <= std_logic_vector(unsigned(temp) + "0001");

						next_state <= check_q_0_and_q_0;

						
						
					when check_q_0_and_q_0 =>
						if (Q_temp(0) = '1' and Q_1(0) = '0')	then
							next_state <= state_10;
						elsif (Q_temp(0) = '0' and Q_1(0) = '1') then 
							next_state <= state_01;
						else 
							next_state <= shift_right ; 
						end if ; 
							
															
					when state_01 => 
					   A <= std_logic_vector(unsigned(A) + unsigned(M)); 
						next_state <= shift_right;
					
					when state_10 =>
					   A <= std_logic_vector(unsigned(A) + unsigned(M_temp_complement)); 
						next_state <= shift_right;
						
					when shift_right => 
						Q_1(0) <= Q_temp(0) ;
						Q_temp(0) <= Q_temp(1) ;
						Q_temp(1) <= Q_temp(2);
						Q_temp(2) <= Q_temp(3);
						Q_temp(3) <= A(0) ;
						A(0) <= A(1) ;
						A(1) <= A(2) ;
						A(2) <= A(3) ;
						
						if (A(3) = '0') then 
							A(3) <= '0';
						elsif (A(3) = '1') then 
							A(3) <= '1' ;
						end if;
							
						next_state <= check_count;

						
					when check_count => 
						 Count <= std_logic_vector(unsigned(Count) - "0001"); 

						if(Count= "0000") then
							next_state <= final_state;
						else 
						   next_state <= check_q_0_and_q_0;
						end if;
						
				
						
				   when final_state => 
					    Q_out(7 downto 4) <= A(3 downto 0);
					    Q_out(3 downto 0) <= Q_temp(3 downto 0);

						 
				end case;
			end process;
		REG : process(clk)
			begin
				if(clk'event and clk = '1') then
					state <= next_state;
				end if;
		end process;
end Behavioral;