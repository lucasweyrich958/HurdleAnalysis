library(readxl)
library(tidyr)
library(dplyr)
library(stringr)

raw_data = read_excel("Path to 110m_data_raw.xlsx") #Read as xlsx

#---Preprocessing----

#Because the first interval shows the step number instead of the first interval, 
#copy the interval form the time row, which is right above it
for (i in 2:nrow(raw_data)) {
  if (grepl("7 steps", raw_data$...16[i])) {
    raw_data$...16[i] = raw_data$...16[i - 1]}} 

cleaned_data = raw_data %>%
  select(...16, ...19, ...22, ...24, ...27, ...30, ...32, ...34, ...36, ...38, ...40) %>%
  mutate_all(~ str_extract_all(., "[0-9.]+") %>% 
             lapply(function(x) paste(x, collapse = " ")))

cleaned_data$Name = raw_data$`Men's 110m Hurdles Touchdown Times - by athletics meeting                                LAST UPDATE:   12-Nov-23`
cleaned_data = cleaned_data %>%
  slice(-1)

#Grab any potential overhang and move it into the column on the right; that way separating the columns that 
#were falsely included
for (i in 1:nrow(cleaned_data)) {
  if (grepl("\\d{1,2}\\.\\d+", cleaned_data$...16[i])) {
    first_number <- gsub("(\\d{1,2}\\.\\d+).*", "\\1", cleaned_data$...16[i])
    remaining_numbers <- gsub("^\\d{1,2}\\.\\d+\\s*", "", cleaned_data$...16[i])
    cleaned_data$...16[i] = first_number
    cleaned_data$...19[i] = paste(cleaned_data$...19[i], remaining_numbers)
  }
}

for (i in 1:nrow(cleaned_data)) {
  if (grepl("\\d{1,2}\\.\\d+", cleaned_data$...19[i])) {
    first_number <- gsub("(\\d{1,2}\\.\\d+).*", "\\1", cleaned_data$...19[i])
    remaining_numbers <- gsub("^\\d{1,2}\\.\\d+\\s*", "", cleaned_data$...19[i])
    cleaned_data$...19[i] = first_number
    cleaned_data$...22[i] = paste(cleaned_data$...22[i], remaining_numbers)
  }
}

for (i in 1:nrow(cleaned_data)) {
  if (grepl("\\d{1,2}\\.\\d+", cleaned_data$...22[i])) {
    first_number <- gsub("(\\d{1,2}\\.\\d+).*", "\\1", cleaned_data$...22[i])
    remaining_numbers <- gsub("^\\d{1,2}\\.\\d+\\s*", "", cleaned_data$...22[i])
    cleaned_data$...22[i] = first_number
    cleaned_data$...24[i] = paste(cleaned_data$...24[i], remaining_numbers)
  }
}

for (i in 1:nrow(cleaned_data)) {
  if (grepl("\\d{1,2}\\.\\d+", cleaned_data$...24[i])) {
    first_number <- gsub("(\\d{1,2}\\.\\d+).*", "\\1", cleaned_data$...24[i])
    remaining_numbers <- gsub("^\\d{1,2}\\.\\d+\\s*", "", cleaned_data$...24[i])
    cleaned_data$...24[i] = first_number
    cleaned_data$...27[i] = paste(cleaned_data$...27[i], remaining_numbers)
  }
}

for (i in 1:nrow(cleaned_data)) {
  if (grepl("\\d{1,2}\\.\\d+", cleaned_data$...27[i])) {
    first_number <- gsub("(\\d{1,2}\\.\\d+).*", "\\1", cleaned_data$...27[i])
    remaining_numbers <- gsub("^\\d{1,2}\\.\\d+\\s*", "", cleaned_data$...27[i])
    cleaned_data$...27[i] = first_number
    cleaned_data$...30[i] = paste(cleaned_data$...30[i], remaining_numbers)
  }
}

for (i in 1:nrow(cleaned_data)) {
  if (grepl("\\d{1,2}\\.\\d+", cleaned_data$...30[i])) {
    first_number <- gsub("(\\d{1,2}\\.\\d+).*", "\\1", cleaned_data$...30[i])
    remaining_numbers <- gsub("^\\d{1,2}\\.\\d+\\s*", "", cleaned_data$...30[i])
    cleaned_data$...30[i] = first_number
    cleaned_data$...32[i] = paste(cleaned_data$...32[i], remaining_numbers)
  }
}

for (i in 1:nrow(cleaned_data)) {
  if (grepl("\\d{1,2}\\.\\d+", cleaned_data$...32[i])) {
    first_number <- gsub("(\\d{1,2}\\.\\d+).*", "\\1", cleaned_data$...32[i])
    remaining_numbers <- gsub("^\\d{1,2}\\.\\d+\\s*", "", cleaned_data$...32[i])
    cleaned_data$...32[i] = first_number
    cleaned_data$...34[i] = paste(cleaned_data$...34[i], remaining_numbers)
  }
}

for (i in 1:nrow(cleaned_data)) {
  if (grepl("\\d{1,2}\\.\\d+", cleaned_data$...34[i])) {
    first_number <- gsub("(\\d{1,2}\\.\\d+).*", "\\1", cleaned_data$...34[i])
    remaining_numbers <- gsub("^\\d{1,2}\\.\\d+\\s*", "", cleaned_data$...34[i])
    cleaned_data$...34[i] = first_number
    cleaned_data$...36[i] = paste(cleaned_data$...36[i], remaining_numbers)
  }
}

for (i in 1:nrow(cleaned_data)) {
  if (grepl("\\d{1,2}\\.\\d+", cleaned_data$...36[i])) {
    first_number <- gsub("(\\d{1,2}\\.\\d+).*", "\\1", cleaned_data$...36[i])
    remaining_numbers <- gsub("^\\d{1,2}\\.\\d+\\s*", "", cleaned_data$...36[i])
    cleaned_data$...36[i] = first_number
    cleaned_data$...38[i] = paste(cleaned_data$...38[i], remaining_numbers)
  }
}

for (i in 1:nrow(cleaned_data)) {
  if (grepl("\\d{1,2}\\.\\d+", cleaned_data$...38[i])) {
    first_number <- gsub("(\\d{1,2}\\.\\d+).*", "\\1", cleaned_data$...38[i])
    remaining_numbers <- gsub("^\\d{1,2}\\.\\d+\\s*", "", cleaned_data$...38[i])
    cleaned_data$...38[i] = first_number
    cleaned_data$...40[i] = paste(cleaned_data$...40[i], remaining_numbers)
  }
}

cleaned_data$...41 = 'x'

for (i in 1:nrow(cleaned_data)) {
  if (grepl("\\d{1,2}\\.\\d+", cleaned_data$...40[i])) {
    first_number <- gsub("(\\d{1,2}\\.\\d+).*", "\\1", cleaned_data$...40[i])
    remaining_numbers <- gsub("^\\d{1,2}\\.\\d+\\s*", "", cleaned_data$...40[i])
    cleaned_data$...40[i] = first_number
    cleaned_data$...41[i] = paste(cleaned_data$...41[i], remaining_numbers)
  }
}

raw_data = raw_data %>%
  slice(-1)
reaction_times = str_match(raw_data$`Men's 110m Hurdles Touchdown Times - by athletics meeting                                LAST UPDATE:   12-Nov-23`,
                           "reaction time\\s+(\\d+\\.\\d+)")[,2]

cleaned_data$RT = NA
cleaned_data[!is.na(reaction_times), "RT"] = reaction_times[!is.na(reaction_times)]  # Fill non-NA values with extracted reaction times


cleaned_data = cleaned_data %>% 
  mutate_all(~ str_replace_all(., "\\bNA\\b", "")) %>%
  select(-...41) %>%
  mutate_all(~ gsub("\\b([0-9]+)\\.([0-9]+)\\b|\\b([0-9]{1,2})\\b", "\\1.\\2", ., perl = TRUE)) %>%
  mutate_all(~ gsub("^(\\s*\\.*)+", "", .))

colnames(cleaned_data) = c("H1", "H2", "H3", "H4", "H5", "H6", "H7", "H8", "H9", "H10", "Run_In","Name", "RT")

cleaned_data <- cleaned_data %>%
  filter(rowSums(. == "" | is.na(.)) < ncol(cleaned_data)) %>%
  mutate(Type = case_when(
    H10 >= 10.00 & H10 <= 20.00 ~ "time",
    H10 >= 0.00 & H10 <= 3.99 ~ "interval",
    H10 >= 5.00 & H10 <= 9.99 ~ "velocity",
    TRUE ~ NA_character_)
  )

cleaned_data$H1 = as.numeric(cleaned_data$H1)
cleaned_data$H2 = as.numeric(cleaned_data$H2)
cleaned_data$H3 = as.numeric(cleaned_data$H3)
cleaned_data$H4 = as.numeric(cleaned_data$H4)
cleaned_data$H5 = as.numeric(cleaned_data$H5)
cleaned_data$H6 = as.numeric(cleaned_data$H6)
cleaned_data$H7 = as.numeric(cleaned_data$H7)
cleaned_data$H8 = as.numeric(cleaned_data$H8)
cleaned_data$H9 = as.numeric(cleaned_data$H9)
cleaned_data$H10 = as.numeric(cleaned_data$H10)
cleaned_data$Run_In = as.numeric(cleaned_data$Run_In)


cleaned_data = cleaned_data %>%
  mutate(Run_In = if_else(
    Type == "time" & is.na(Run_In),
    H10 + lead(Run_In, default = 0),
    Run_In
  ))

cleaned_data = cleaned_data %>%
  mutate(H1 = if_else(
    Type == "interval" & is.na(H1),
    lag(H1),
    H1
  ))

cleaned_data = cleaned_data %>%
  mutate(H1 = if_else(
    Type == "interval" & is.na(H1),
    round(13.72/lead(H1), 2), #Divide velocity by first hurdle distance (13.72m)
    H1
  ))

cleaned_data = cleaned_data %>%
  mutate(H1 = if_else(
    Type == "time" & is.na(H1),
    lead(H1),
    H1
  ))

cleaned_data = cleaned_data %>%
  drop_na(Type)

pattern = c("time", "interval", "velocity")

column = cleaned_data$Type

match_indices = which(column == pattern[1])

rows_to_keep = c()

for (index in match_indices) {
  if (index <= length(column) - length(pattern) + 1) {
    if (all(column[index:(index + length(pattern) - 1)] == pattern)) {
      rows_to_keep = c(rows_to_keep, index:(index + length(pattern) - 1))
    }
  }
}

rows_to_keep = unique(rows_to_keep)
cleaned_data = cleaned_data[rows_to_keep, , drop = FALSE]

rows_to_remove = which(
  cleaned_data$Type == "time" & cleaned_data$Run_In < 12.80 &
    lag(cleaned_data$Type, 1) %in% c("interval", "velocity") &
    lag(cleaned_data$Type, 2) %in% c("interval", "velocity")
)
rows_to_remove =unique(c(rows_to_remove, rows_to_remove + 1, rows_to_remove + 2))
cleaned_data = cleaned_data %>% slice(-rows_to_remove)

for (i in seq(1, nrow(cleaned_data), by=3)) {
  if (i + 1 <= nrow(cleaned_data)) {
    cleaned_data$Name[i + 1] = cleaned_data$Name[i]
  }
  if (i + 2 <= nrow(cleaned_data)) {
    cleaned_data$Name[i + 2] = cleaned_data$Name[i]
  }
}

cleaned_data$Name = sub("\\(.*", "", cleaned_data$Name)

cleaned_data$Name = trimws(cleaned_data$Name) # Trim any trailing whitespace

time = cleaned_data %>%
  filter(Type == "time")
interval = cleaned_data %>%
  filter(Type == "interval")
velocity = cleaned_data %>%
  filter(Type == "velocity")
  
colnames(time) = c("H1_time", "H2_time", "H3_time", "H4_time", "H5_time", "H6_time", 
                   "H7_time", "H8_time", "H9_time", "H10_time", "Final_time","Namex", "RTx", "Typex")
colnames(interval) = c("H1_interval", "H2_interval", "H3_interval", "H4_interval", "H5_interval", "H6_interval", 
                   "H7_interval", "H8_interval", "H9_interval", "H10_interval", "Run_In_interval","Name", "RT", "Typey")
colnames(velocity) = c("H1_velocity", "H2_velocity", "H3_velocity", "H4_velocity", "H5_velocity", "H6_velocity", 
                       "H7_velocity", "H8_velocity", "H9_velocity", "H10_velocity", "Run_In_velocity","Namey", "RTy", "Typez")

final_data_set = cbind(time, interval, velocity)
final_data_set = final_data_set %>%
  slice(-1) %>%
  select(-c(RTx, Typex, Typey, RTy, Typez, H1_time, H2_time, H3_time, H4_time, H5_time, H6_time, H7_time, H8_time
         ,H9_time, H10_time, Namex, Namey))

WR = data.frame(Final_time = 12.80, H1_interval = 2.52, H2_interval = 1.04, H3_interval = 1.00, H4_interval = 0.97,
                H5_interval = 0.97, H6_interval = 0.98, H7_interval = 0.98, H8_interval = 0.98, H9_interval = 1.00,
                H10_interval = 1.02, Run_In_interval = 1.34, Name = "Merritt, Aries", RT = 0.145, H1_velocity = 5.44, H2_velocity = 8.79,
                H3_velocity = 9.14, H4_velocity = 9.42, H5_velocity = 9.42, H6_velocity = 9.33, H7_velocity = 9.33,
                H8_velocity = 9.33, H9_velocity = 9.14, H10_velocity = 8.96, Run_In_velocity = 10.46)

final_data_set = rbind(final_data_set, WR)
final_data_set <- final_data_set[!grepl("^[0-9.]+$", final_data_set$Name), ]

final_data_set = drop_na(final_data_set)
write.csv(final_data_set, "110m_H_df_RT.csv")
