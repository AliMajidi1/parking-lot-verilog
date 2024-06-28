module parking_logic (
    input wire clk,
    input wire reset,
    input wire car_entered,
    input wire is_uni_car_entered,
    input wire car_exited,
    input wire is_uni_car_exited,
    input wire [4:0] hour,
    output reg [9:0] uni_parked_car,
    output reg [9:0] parked_car,
    output reg [9:0] uni_vacated_space,
    output reg [9:0] vacated_space,
    output reg uni_is_vacated_space,
    output reg is_vacated_space
);

    parameter TOTAL_CAP = 700;
    parameter UNI_CAP = 500;
    parameter OPEN_TIME = 8;
    parameter START_INC_TIME = 13;
    parameter END_INC_TIME = 16;
    parameter INC_PER_HOUR = 50;
    parameter MAX_NON_UNI_CAP_END = 500;

    reg [9:0] non_uni_capacity;

    // Update vacated spaces and flags
    always @(*) begin
        uni_vacated_space = UNI_CAP - uni_parked_car < TOTAL_CAP - (uni_parked_car + parked_car) 
        ? UNI_CAP - uni_parked_car : TOTAL_CAP - (uni_parked_car + parked_car);
        vacated_space = non_uni_capacity - parked_car < TOTAL_CAP - (uni_parked_car + parked_car) 
        ? non_uni_capacity - parked_car : TOTAL_CAP - (uni_parked_car + parked_car);
        uni_is_vacated_space = (uni_vacated_space > 0);
        is_vacated_space = (vacated_space > 0);
    end

    // Parking logic for entering and exiting cars
    always @(posedge clk or negedge reset) begin
        if (reset) begin
            non_uni_capacity <= TOTAL_CAP - UNI_CAP;
            uni_parked_car <= 0;
            parked_car <= 0;
        end else begin
            updateNonEmployeeCapacity();
            processCarEntered();
            processCarExited();
        end
    end

    // Update non-employee capacity based on the hour
    task updateNonEmployeeCapacity();
        if (hour >= OPEN_TIME && hour < START_INC_TIME) begin
            non_uni_capacity <= TOTAL_CAP - UNI_CAP;
        end else if (hour >= START_INC_TIME && hour < END_INC_TIME) begin
            non_uni_capacity <= TOTAL_CAP - UNI_CAP + (hour - START_INC_TIME) * INC_PER_HOUR;
        end else if (hour >= END_INC_TIME) begin
            non_uni_capacity <= MAX_NON_UNI_CAP_END;
        end
    endtask

    // Process car entered events
    task processCarEntered();
        if (car_entered) begin
            if (uni_parked_car + parked_car >= TOTAL_CAP) begin
                $display("Parking lot is full. Car cannot be parked.");
            end else if (is_uni_car_entered && uni_parked_car < UNI_CAP) begin
                uni_parked_car <= uni_parked_car + 1;
            end else if (!is_uni_car_entered && parked_car < non_uni_capacity) begin
                parked_car <= parked_car + 1;
            end
        end
    endtask

    // Process car exited events
    task processCarExited();
        if (car_exited) begin
            if (is_uni_car_exited && uni_parked_car > 0) begin
                uni_parked_car <= uni_parked_car - 1;
            end else if (!is_uni_car_exited && parked_car > 0) begin
                parked_car <= parked_car - 1;
            end
        end
    endtask

endmodule