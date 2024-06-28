
![LOGO](https://media.shahr.ir/d/2021/11/27/2/21194.jpg)



# Parking lot logic
This project is a logic for parking that controls the entry and exit of cars


## Tools
In this section, you should mention the hardware or simulators utilized in your project.
- Verilog
- Quartus
- ModelSim


## Implementation Details

### Implementation Details for `parking_logic` Verilog Module

#### Overview
The `parking_logic` module is designed to manage the parking space allocation in a university parking lot, ensuring priority for university vehicles. The parking capacity varies throughout the day, with specific hours allocated more capacity for non-university vehicles. This module keeps track of the number of parked university and non-university vehicles and the available parking spaces for each category.

#### Inputs
- `clk`: Clock signal.
- `reset`: Reset signal to initialize the module.
- `car_entered`: Signal indicating a car has entered the parking.
- `is_uni_car_entered`: Signal indicating if the entering car belongs to the university.
- `car_exited`: Signal indicating a car has exited the parking.
- `is_uni_car_exited`: Signal indicating if the exiting car belongs to the university.
- `hour [4:0]`: Current hour in 24-hour format.

#### Outputs
- `uni_parked_car [9:0]`: Number of university cars currently parked.
- `parked_car [9:0]`: Number of non-university cars currently parked.
- `uni_vacated_space [9:0]`: Number of vacant spaces for university cars.
- `vacated_space [9:0]`: Number of vacant spaces for non-university cars.
- `uni_is_vacated_space`: Indicates if there is at least one vacant space for university cars.
- `is_vacated_space`: Indicates if there is at least one vacant space for non-university cars.

#### Internal Register
- `non_uni_capacity [9:0]`: Capacity for non-university vehicles, dynamically adjusted based on the hour.

#### Logic
1. **Capacity Management:**
   - Between 08:00 and 13:00, the capacity for non-university vehicles is 200.
   - Between 13:00 and 16:00, the capacity increases by 50 each hour, reaching 350 at 16:00.
   - After 16:00, the capacity is set to 500.

2. **Car Entry and Exit Management:**
   - On the entry of a car (`car_entered`), the module checks if the car is a university vehicle (`is_uni_car_entered`):
     - If it is and the count of university cars is less than 500, the university car count is incremented.
     - If it is not and the count of non-university cars is less than `non_employee_capacity`, the non-university car count is incremented.
   - On the exit of a car (`car_exited`), the module checks if the car is a university vehicle (`is_uni_car_exited`):
     - If it is and the count of university cars is greater than 0, the university car count is decremented.
     - If it is not and the count of non-university cars is greater than 0, the non-university car count is decremented.

3. **Vacancy Status:**
   - The number of vacant spaces for university cars is calculated as `500 - uni_parked_car`.
   - The number of vacant spaces for non-university cars is calculated as `non_employee_capacity - parked_car`.
   - `uni_is_vacated_space` is true if there are any vacant spaces for university cars.
   - `is_vacated_space` is true if there are any vacant spaces for non-university cars.



This Verilog module ensures efficient management of university parking spaces, providing real-time status updates on available parking slots for both university and non-university vehicles.

## How to Run
### Step-by-Step Guide to Run the Testbench in ModelSim

#### Step 1: Open ModelSim

1. Launch ModelSim from your applications menu or command line.

#### Step 2: Create a New Project

1. **File > New > Project**
2. Enter a project name and choose a location to save your project files.
3. Click `OK`.

#### Step 3: Add Source Files

1. **Add Existing File**
   - Add your Verilog source file `parking_logic.v`.
   - Add your testbench file `university_parking_tb.v`.

#### Step 4: Compile the Design

1. In the **Library** window, right-click on your project library (usually `work`) and select **Add to Library > Native**.
2. In the **Workspace** window, you should see your source and testbench files listed.
3. Select both files, right-click, and choose **Compile > Compile Selected**.

   - Ensure there are no syntax errors. If there are errors, fix them in the source files and recompile.

#### Step 5: Set Up the Simulation

1. **Simulate > Start Simulation**
2. In the **Library** tab, expand your project library (usually `work`).
3. Select `university_parking_tb` and click `OK`.

#### Step 6: Run the Simulation

1. **View > Objects**: This opens the Objects window where you can see the signals and variables.
2. **View > Wave**: This opens the Wave window where you can add signals to be monitored.
3. In the Objects window, select the signals you want to monitor (e.g., `uni_parked_car`, `parked_car`, `uni_vacated_space`, `vacated_space`, `uni_is_vacated_space`, `is_vacated_space`).
4. Right-click and choose **Add to Wave > Selected Signals**.
5. In the ModelSim command line (Transcript window), type `run -all` to run the simulation until it finishes or stops.

   Alternatively, you can run for a specific time by typing commands like `run 1000ns`.

#### Step 7: Analyzing the Results

1. **Wave Window**: Observe the waveforms for the monitored signals. You can zoom in/out and navigate through the simulation time.
2. **Transcript Window**: Check the output for any `$monitor` messages or other print statements to understand the simulation behavior.

### Step-by-Step Guide for Synthesis and Timing Analysis in Quartus

#### Step 1: Open Quartus Prime

1. Launch Quartus Prime from your applications menu or command line.

#### Step 2: Create a New Project

1. **File > New Project Wizard**
2. Click `Next` to start the wizard.
3. Enter a directory for your project, a name for the project, and a name for the top-level entity (e.g., `parking_logic`). Click `Next`.
4. Add your Verilog source files:
   - Add `parking_logic.v`.
   - Add `university_parking_tb.v` if you want to include the testbench, but for synthesis focus on the `parking_logic.v`.
5. Click `Next` to proceed.
6. Select your target FPGA device. If you don't know which device to choose, you can select a default one (e.g., Cyclone IV E, EP4CE22F17C6). Click `Next`.
7. Click `Finish` to create the project.

#### Step 3: Add Source Files

1. **Project > Add/Remove Files in Project**
2. Add your Verilog source files (`parking_logic.v`).

#### Step 4: Set the Top-Level Entity

1. **Assignments > Settings**
2. In the `Category` list, select `General`.
3. Set the `Top-level entity` to `parking_logic`. Click `OK`.

#### Step 5: Compile the Design

1. **Processing > Start Compilation**
2. Wait for the compilation to complete. Ensure there are no errors. Warnings are typically acceptable but review them to ensure they don't impact the design.

#### Step 6: Perform Timing Analysis

1. **Tools > TimeQuest Timing Analyzer**
2. In the in Tasks section, click on `Create Timing Netlist`, `Read SDC`, `Update Timing Netlist`.

#### Step 7: Review the Timing Report

1. Look for the section titled `Report Fmax Summary` to find the maximum clock frequency (fmax).
   - The `fmax` value represents the maximum clock frequency at which design can operate reliably.
2. Look for the section titled `Report Top Falling Paths` to find each path delay.




## Results
You can see test bench results in:

text file:
[text file](https://github.com/AliMajidi1/parking-lot-verilog/blob/main/monitor_result.txt)

vcd file:
[vcd file](https://github.com/AliMajidi1/parking-lot-verilog/blob/main/university_parking_tb.vcd)

Fmax summary:

![Fmax summary](https://github.com/AliMajidi1/parking-lot-verilog/blob/main/fmax_summary.jpg)

Delay of some paths (sorted by maximum delay):

![paths delay](https://github.com/AliMajidi1/parking-lot-verilog/blob/main/paths.jpg)


## Authors
- [Ali Majidi](https://github.com/AliMajidi1)

