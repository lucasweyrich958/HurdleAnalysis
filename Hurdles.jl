using DataFrames
using CSV
using Plots
using Statistics
using StatsPlots
using Polynomials

hurdles_df = CSV.read("Path to 110m_H_df_RT.csv", DataFrame)

#----Remove Outliers----
numeric_cols = [col for col in names(hurdles_df) if eltype(hurdles_df[!, col]) <: Number] #Find numeric columns

means = Dict(col => mean(hurdles_df[!, col]) for col in numeric_cols)
std_devs = Dict(col => std(hurdles_df[!, col]) for col in numeric_cols)

outlier_mask = [any(col in numeric_cols && abs(hurdles_df[row, col] - means[col]) > 4 * std_devs[col] for col in numeric_cols) for row in 1:nrow(hurdles_df)]

hurdles_df = hurdles_df[.!outlier_mask, :]

#----EDA----
println(describe(hurdles_df, :all))
interval_ta = hurdles_df[:, [:H1_interval, :H2_interval, :H3_interval, :H4_interval, :H5_interval, 
    :H6_interval, :H7_interval, :H8_interval, :H9_interval, :H10_interval, :Run_In_interval]]

means_interval = [mean(col) for col in eachcol(interval_ta)]
scatter(names(interval_ta), means_interval, markershape=:circle, legend=false, xlabel="Hurdles", ylabel="Seconds")
plot!(names(interval_ta), means_interval, line=:true, xlabel="Hurdles", ylabel="Interval (seconds)", xticks = (1:11,["H1", "H2", "H3", "H4", "H5", "H6",
    "H7", "H8", "H9", "H10", "Run-In"]), title = "Mean Interval")

velocity_ta = hurdles_df[:, [:H1_velocity, :H2_velocity, :H3_velocity, :H4_velocity, :H5_velocity, 
    :H6_velocity, :H7_velocity, :H8_velocity, :H9_velocity, :H10_velocity, :Run_In_velocity]]

means_velocity = [mean(col) for col in eachcol(velocity_ta)]
scatter(names(velocity_ta), means_velocity, markershape=:circle, legend=false, xlabel="Hurdles", ylabel="m/s")
plot!(names(velocity_ta), means_velocity, line=:true, xlabel="Hurdles", ylabel="Velocity (m/s)", xticks = (1:11,["H1", "H2", "H3", "H4", "H5", "H6",
    "H7", "H8", "H9", "H10", "Run-In"]), title = "Mean Velocity")

intervals = mean.(eachrow(interval_ta))
velocitys = mean.(eachrow(velocity_ta))

scatter(intervals, velocitys, xlabel="Interval (s)", ylabel="Velocity (m/s)", title="Interval vs. Velocity", legend = false)
fit_line = fit(intervals, velocitys, 1)
x_values = minimum(intervals):0.01:maximum(intervals)
plot!(x_values, fit_line.(x_values), label="Line of Best Fit", lw = 3, linecolor = :orange)

scatter(hurdles_df.Final_time, velocitys, xlabel="Final Time (s)", ylabel="Velocity (m/s)", title="Final Time vs. Velocity", legend = false)
fit_line = fit(hurdles_df.Final_time, velocitys, 1)
x_values = minimum(hurdles_df.Final_time):0.01:maximum(hurdles_df.Final_time)
plot!(x_values, fit_line.(x_values), label="Line of Best Fit", lw = 3, linecolor = :orange)

scatter(hurdles_df.Final_time, hurdles_df.RT, xlabel="Final Time (s)", ylabel="Reaction Time (s)", title="Final Time vs. Reaction Time", legend = false)
fit_line = fit(hurdles_df.Final_time, hurdles_df.RT, 1)
x_values = minimum(hurdles_df.Final_time):0.01:maximum(hurdles_df.Final_time)
plot!(x_values, fit_line.(x_values), label="Line of Best Fit", lw = 3, linecolor = :orange)


h1 = histogram(hurdles_df.Final_time, legend=false, title="Final Time")
h2 = histogram(hurdles_df.H1_interval, legend=false, title="H1 Interval")
h3 = histogram(hurdles_df.H2_interval, legend=false, title="H2 Interval")
h4 = histogram(hurdles_df.H3_interval, legend=false, title="H3 Interval")
h5 = histogram(hurdles_df.H4_interval, legend=false, title="H4 Interval")
h6 = histogram(hurdles_df.H5_interval, legend=false, title="H5 Interval")
h7 = histogram(hurdles_df.H6_interval, legend=false, title="H6 Interval")
h8 = histogram(hurdles_df.H7_interval, legend=false, title="H7 Interval")
h9 = histogram(hurdles_df.H8_interval, legend=false, title="H8 Interval")
h10 = histogram(hurdles_df.H9_interval, legend=false, title="H9 Interval")
h11 = histogram(hurdles_df.H10_interval, legend=false, title="H10 Interval")
h12 = histogram(hurdles_df.H1_velocity, legend=false, title="H1 Velocity")
h13 = histogram(hurdles_df.H2_velocity, legend=false, title="H2 Velocity")
h14 = histogram(hurdles_df.H3_velocity, legend=false, title="H3 Velocity")
h15 = histogram(hurdles_df.H4_velocity, legend=false, title="H4 Velocity")
h16 = histogram(hurdles_df.H5_velocity, legend=false, title="H5 Velocity")
h17 = histogram(hurdles_df.H6_velocity, legend=false, title="H6 Velocity")
h18 = histogram(hurdles_df.H7_velocity, legend=false, title="H7 Velocity")
h19 = histogram(hurdles_df.H8_velocity, legend=false, title="H8 Velocity")
h20 = histogram(hurdles_df.H9_velocity, legend=false, title="H9 Velocity")
h21 = histogram(hurdles_df.H10_velocity, legend=false, title="H10 Velocity")
h22 = histogram(hurdles_df.RT, legend=false, title="Reaction Time")

plot(h1,h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12, h13, h14, 
    h15, h16, h17, h18, h19, h20, h21, h22, legend=false, size = (1600, 1400))

cor_matrix = cor(Matrix(velocity_ta[:, 1:11]))
heatmap(cor_matrix, xlabel="Hurdle", ylabel="Hurdle", title="Correlation of Velocities")

cor_matrix = cor(Matrix(interval_ta[:, 1:11]))
heatmap(cor_matrix, xlabel="Hurdle", ylabel="Hurdle", title="Correlation of Intervals")

#----Model in R----
using RCall
using Random

Random.seed!(1290)

model_df = copy(hurdles_df)
select!(model_df, Not(:Name))

n_train = Int(0.8 * 1175)
train_indices = 1:n_train
test_indices = (n_train + 1):1177
y = select(model_df, 1)
x = select(model_df, Not(1))

train = (model_df[train_indices, :])
y_train = (y[train_indices, :])
test = model_df[test_indices, :]
y_test = y[test_indices, :]
y_test = y_test[:,1]

@rput train #Copy train df to R
@rput test #Copy test df to R

R"""
library(randomForest)
library(randomForestExplainer)

model = randomForest(Final_time ~ ., 
                      data = train, ntree = 120, mtry = (23/3)) #Run model in R

predictions = predict(model, newdata = test)
"""

predictions = rcopy(R"predictions") #Bring predictions back to Julia
predictions = predictions[:,1]

mse = mean((predictions .- y_test).^2)
mae = mean(abs.(predictions .- y_test))
r2_score = 1 - sum((y_test .- predictions).^2) / sum((y_test .- mean(y_test)).^2)

# Scatter plot of actual vs predicted values with line of best fit
scatter(y_test, predictions, xlabel="Actual", ylabel="Predicted", title="Actual vs Predicted Values", legend=false)
fit_line = fit(y_test, predictions, 1)
x_values = minimum(y_test):0.01:maximum(y_test)
plot!(x_values, fit_line.(x_values), label="Line of Best Fit", lw = 3, linecolor = :orange)
annotate!(13, 15.2, text("MAE: 0.14", :bottom, 10))

residuals = predictions .- y_test
e1 = histogram(residuals, xlabel="Residuals", ylabel="Frequency", title="Histogram of Residuals", legend=false)

e2 =scatter(predictions, residuals, xlabel="Predicted", ylabel="Residuals", title="Residual Plot", legend=false)
hline!([0], color="red", linestyle=:dash, label="Zero Residuals", lw = 2.5)

plot(e1,e2)
qqnorm(residuals, xlabel="Theoretical Quantiles", ylabel="Sample Quantiles", title="Q-Q Plot")

#----SHAP Values in R & Other Plots----
using RCall
R"""
library(shapviz)
library(kernelshap)

shap_values = kernelshap(model, test[,-1], bg_X = test)
sv = shapviz(shap_values)
shap_plot = sv_importance(sv, kind = "bee", max_display = 25, show_numbers = TRUE)
"""

s1 = scatter(hurdles_df.Final_time, hurdles_df.H7_velocity, title="Hurdle 7")
s2 = scatter(hurdles_df.Final_time, hurdles_df.H8_velocity, title="Hurdle 8")
s3 = scatter(hurdles_df.Final_time, hurdles_df.H9_velocity, title="Hurdle 9")
s4 = scatter(hurdles_df.Final_time, hurdles_df.H10_velocity, title="Hurdle 10")
s5 = scatter(hurdles_df.Final_time, hurdles_df.H2_velocity, title="Hurdle 2")

plot(s1, s2, s3, s4, legend = false, xlabel = "Final Time (s)", ylabel = "Interval (s)")
plot(s1, s5, legend = false, xlabel = "Final Time (s)", ylabel = "Interval (s)")

R"""
library(shapviz)
library(kernelshap)

wr_shap = kernelshap(model, test[,-1], bg_X = test)
sv_wr = shapviz(wr_shap)
sv_waterfall(sv_wr, row_id = 237)
"""

#----Plot World Record Race----
velocity_WR = hurdles_df[1176:1177, [:H1_velocity, :H2_velocity, :H3_velocity, :H4_velocity, :H5_velocity, 
    :H6_velocity, :H7_velocity, :H8_velocity, :H9_velocity, :H10_velocity, :Run_In_velocity]]

velocity_WR_vector = collect(velocity_WR[2, :]) 
  
#Plot combination of mean velocity and WR
wr_v = plot(names(velocity_WR), velocity_WR_vector, line=:true, legend=true,xlabel="Hurdles", ylabel="Velocity (m/s)", xticks = (1:11,["H1", "H2", "H3", "H4", "H5", "H6",
    "H7", "H8", "H9", "H10", "Run-In"]), labels = "Aries Merritt @ WR")
wr_v = plot!(names(velocity_ta), means_velocity, line=:true, xlabel="Hurdles", ylabel="Velocity (m/s)", xticks = (1:11,["H1", "H2", "H3", "H4", "H5", "H6",
    "H7", "H8", "H9", "H10", "Run-In"]), labels = "Mean Velocity", legend = :bottom, legendfont = font(7))

interval_WR = hurdles_df[1176:1177, [:H1_interval, :H2_interval, :H3_interval, :H4_interval, :H5_interval, 
    :H6_interval, :H7_interval, :H8_interval, :H9_interval, :H10_interval, :Run_In_interval]]

interval_WR_vector = collect(interval_WR[2, :])

wr_i = plot(names(interval_WR), interval_WR_vector, line=:true, xlabel="Hurdles", ylabel="Interval (seconds)", xticks = (1:11,["H1", "H2", "H3", "H4", "H5", "H6",
    "H7", "H8", "H9", "H10", "Run-In"]), labels = "Aries Merritt @ WR")
wr_i = plot!(names(interval_ta), means_interval, line=:true, xlabel="Hurdles", ylabel="Interval (seconds)", xticks = (1:11,["H1", "H2", "H3", "H4", "H5", "H6",
    "H7", "H8", "H9", "H10", "Run-In"]), labels = "Mean Velocity", legend = :top, legendfont = font(7))

#----Time-To-Event Analysis----
#Test the impact of velocity loss at each hurdle and its importance

using StatsBase
using Survival
using Plots

velocity_s = hurdles_df[:, [:H1_velocity, :H2_velocity, :H3_velocity, :H4_velocity, :H5_velocity, 
    :H6_velocity, :H7_velocity, :H8_velocity, :H9_velocity, :H10_velocity, :Run_In_velocity, :Final_time]]

slowdown_threshold = -3

for i in 1:(10-1)
    velocity_current = velocity_s[!, i+1]
    velocity_next = velocity_s[!, i+2]
    velocity_change = (velocity_next .- velocity_current) ./ velocity_current .* 100
    velocity_s[!, "velocity_change_h$(i)_h$(i+1)"] = velocity_change
    velocity_s[!, "slowdown_h$(i)_h$(i+1)"] = velocity_change .< slowdown_threshold
end

event_times = Int[]
event_indicators = Bool[]

for i in 1:nrow(velocity_s)
    slowdown_index = findfirst(x -> x, [velocity_s[i, "slowdown_h$(j)_h$(j+1)"] for j in 1:(10-1)])
    if isnothing(slowdown_index)
        push!(event_times, 10)
        push!(event_indicators, false)
    else
        push!(event_times, slowdown_index)
        push!(event_indicators, true)
    end
end

event_table = Survival.EventTable(event_times, event_indicators)

km_fit = Survival.fit(KaplanMeier, event_table)

km_probs = km_fit.survival
km_hurdles = event_table.time

plot(km_hurdles, km_probs, title="Kaplan-Meier Survival Curve", xlabel="Hurdle Number", ylabel="Survival Probability", lw=2,
    legend=false)
annotate!(7.7, 0.9, text("Chance of NOT losing 3% velocity", :bottom, 10))

#Visualize the probability of experience a velocity loss of 5% with final time
event_times = Float64[]
event_indicators = Bool[]

for i in 1:nrow(velocity_s)
    slowdown_index = findfirst(x -> x, [velocity_s[i, "slowdown_h$(j)_h$(j+1)"] for j in 1:(10-1)])
    if isnothing(slowdown_index)
        push!(event_times, velocity_s.Final_time[i])
        push!(event_indicators, false)
    else
        push!(event_times, velocity_s.Final_time[i])
        push!(event_indicators, true)
    end
end

event_table_time = Survival.EventTable(event_times, event_indicators)

km_fit_time = Survival.fit(KaplanMeier, event_table_time)

km_probs_time = km_fit_time.survival
km_times = event_table_time.time

plot(km_times, km_probs_time, title="Kaplan-Meier Survival Curve", xlabel="Time", ylabel="Survival Probability", lw=2, legend=false)
annotate!(15.1, 0.9, text("Chance of NOT losing 3% velocity", :bottom, 10))


#----Athlete Analysis----
athlete_selection = hurdles_df[:, [:H1_velocity, :H2_velocity, :H3_velocity, :H4_velocity, :H5_velocity, 
    :H6_velocity, :H7_velocity, :H8_velocity, :H9_velocity, :H10_velocity, :Run_In_velocity, :Name]]
athlete_selection = filter(row -> in(row.Name, ["Merritt, Aries", "Holloway, Grant", 
    "Martinot-Lagarde, Pascal", "McLeod, Omar"]), athlete_selection)

averaged_athletes = combine(groupby(athlete_selection, :Name), names(athlete_selection, Not(:Name)) .=> mean)

athletes_matrix = Matrix(averaged_athletes[:, 2:end])
plot(athletes_matrix', label = ["Grant Holloway (OC'20)" "Pascal Martinot-Lagarde (EU'18)" "Omar McLeod (OC'16)" "Aries Merritt (WR'12)"], 
    xlabel = "Hurdle", ylabel = "Velocity", title = "Selected Athletes Velocity", legend = :bottom, legendfont = font(7))

