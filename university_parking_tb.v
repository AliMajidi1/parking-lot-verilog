module university_parking_tb;

parameter CLK_PERIOD = 10; // Clock period in nanoseconds
parameter SIM_END_TIME = 10000; // Simulation end time in nanoseconds

reg clk;
reg reset;
reg car_entered;
reg is_uni_car_entered;
reg car_exited;
reg is_uni_car_exited;
reg [4:0] hour;

wire [9:0] uni_parked_car;
wire [9:0] parked_car;
wire [9:0] uni_vacated_space;
wire [9:0] vacated_space;
wire uni_is_vacated_space;
wire is_vacated_space;

parking_logic pl (
    .clk(clk),
    .reset(reset),
    .car_entered(car_entered),
    .is_uni_car_entered(is_uni_car_entered),
    .car_exited(car_exited),
    .is_uni_car_exited(is_uni_car_exited),
    .hour(hour),
    .uni_parked_car(uni_parked_car),
    .parked_car(parked_car),
    .uni_vacated_space(uni_vacated_space),
    .vacated_space(vacated_space),
    .uni_is_vacated_space(uni_is_vacated_space),
    .is_vacated_space(is_vacated_space)
);

initial clk = 0;
always #(CLK_PERIOD / 2) clk = ~clk;

task reset_sequence;
begin
    reset = 1;
    #(2 * CLK_PERIOD) reset = 0;
end
endtask

task simulate_car_activity(input integer uni_enter, uni_exit, non_uni_enter, non_uni_exit);
integer i;
begin
    for (i = 0; i < uni_enter; i++) begin
        #(CLK_PERIOD) car_entered = 1; is_uni_car_entered = 1; #(CLK_PERIOD) car_entered = 0;
    end
    for (i = 0; i < non_uni_enter; i++) begin
        #(CLK_PERIOD) car_entered = 1; is_uni_car_entered = 0; #(CLK_PERIOD) car_entered = 0;
    end
    for (i = 0; i < uni_exit; i++) begin
        #(CLK_PERIOD) car_exited = 1; is_uni_car_exited = 1; #(CLK_PERIOD) car_exited = 0;
    end
    for (i = 0; i < non_uni_exit; i++) begin
        #(CLK_PERIOD) car_exited = 1; is_uni_car_exited = 0; #(CLK_PERIOD) car_exited = 0;
    end
end
endtask

initial begin
    $monitor("Hour: %d, uni_parked_car: %d, parked_car: %d, uni_vacated_space: %d, vacated_space: %d, uni_is_vacated_space: %b, is_vacated_space: %b", 
        hour, uni_parked_car, parked_car, uni_vacated_space, vacated_space, uni_is_vacated_space, is_vacated_space);
    $dumpfile("university_parking_tb.vcd");
    $dumpvars(0, university_parking_tb);

    reset_sequence();
    hour = 8; simulate_car_activity(500, 0, 200, 100);
    hour = 14; simulate_car_activity(0, 100, 100, 0);
    hour = 15; simulate_car_activity(0, 100, 200, 0);
    hour = 16; simulate_car_activity(50, 0, 50, 0);

    #(SIM_END_TIME) $stop;
end

endmodule