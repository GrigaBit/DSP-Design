module FIFO (
    input wire clk,
    input wire rst,
    input wire W_En,
    input wire R_En,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);

    parameter Dim = 32;
    reg [15:0] CBuffer [0:Dim-1];
    reg [4:0] write_ptr = 0;
    reg [4:0] read_ptr = 0;
    reg [5:0] count = 0;

    wire full  = (count == Dim);
    wire empty = (count == 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            write_ptr <= 0;
            read_ptr <= 0;
            count <= 0;
            data_out <= 0;
        end else begin
            if (W_En && !full) begin
                CBuffer[write_ptr] <= data_in;
                write_ptr <= (write_ptr + 1) & (Dim - 1);
                count <= count + 1;
            end

            if (R_En && !empty) begin
                data_out <= CBuffer[read_ptr];
                read_ptr <= (read_ptr + 1) & (Dim - 1);
                count <= count - 1;
            end
        end
    end

endmodule
