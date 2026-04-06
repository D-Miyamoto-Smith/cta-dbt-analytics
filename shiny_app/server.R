server <- function(input, output, session) {

  # --- Monthly Trend ---
  output$monthly_trend <- renderPlotly({
    p <- ggplot(monthly, aes(x = month, y = total_rides)) +
      geom_line(color = "#00b4d8", linewidth = 0.8) +
      geom_area(fill = "#00b4d8", alpha = 0.1) +
      annotate("rect",
        xmin = as.Date("2020-03-01"),
        xmax = as.Date("2021-06-01"),
        ymin = -Inf, ymax = Inf,
        fill = "#ff6b6b", alpha = 0.15
      ) +
      annotate("text",
        x = as.Date("2020-09-01"), y = max(monthly$total_rides) * 0.95,
        label = "COVID-19", color = "#ff6b6b", size = 3.5
      ) +
      scale_y_continuous(labels = scales::comma) +
      scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
      labs(x = NULL, y = "Total Rides") +
      theme_minimal(base_size = 13) +
      theme(
        plot.background = element_rect(fill = "#222222", color = NA),
        panel.background = element_rect(fill = "#222222", color = NA),
        text = element_text(color = "#ffffff"),
        axis.text = element_text(color = "#aaaaaa"),
        panel.grid.major = element_line(color = "#333333"),
        panel.grid.minor = element_blank()
      )
    ggplotly(p, tooltip = c("x", "y")) %>%
      layout(paper_bgcolor = "#222222", plot_bgcolor = "#222222")
  })

  # --- Bus vs Rail ---
output$bus_vs_rail <- renderPlotly({
    p <- monthly %>%
      select(month, total_bus_boardings, total_rail_boardings) %>%
      pivot_longer(cols = c(total_bus_boardings, total_rail_boardings),
                   names_to = "mode", values_to = "boardings") %>%
      mutate(mode = recode(mode,
        "total_bus_boardings" = "Bus",
        "total_rail_boardings" = "Rail"
      )) %>%
      ggplot(aes(x = month, y = boardings, color = mode)) +
      geom_line(linewidth = 0.7) +
      scale_color_manual(values = c("Bus" = "#f4a261", "Rail" = "#00b4d8")) +
      scale_y_continuous(labels = scales::comma) +
      scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
      labs(x = NULL, y = "Boardings", color = NULL) +
      theme_minimal(base_size = 13) +
      theme(
        plot.background = element_rect(fill = "#222222", color = NA),
        panel.background = element_rect(fill = "#222222", color = NA),
        text = element_text(color = "#ffffff"),
        axis.text = element_text(color = "#aaaaaa"),
        panel.grid.major = element_line(color = "#333333"),
        panel.grid.minor = element_blank(),
        legend.background = element_rect(fill = "#222222", color = NA)
      )

    ggplotly(p, tooltip = c("x", "y", "colour")) %>%
      layout(paper_bgcolor = "#222222", plot_bgcolor = "#222222")
  })

  # --- Rail Share ---
  output$rail_share <- renderPlotly({
    p <- ggplot(monthly, aes(x = month, y = rail_pct_of_total)) +
      geom_line(color = "#a8dadc", linewidth = 0.7) +
      geom_smooth(method = "loess", se = FALSE,
                  color = "#ffffff", linewidth = 0.4, linetype = "dashed") +
      scale_y_continuous(labels = scales::percent_format(scale = 1)) +
      scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
      labs(x = NULL, y = "Rail % of Total") +
      theme_minimal(base_size = 13) +
      theme(
        plot.background = element_rect(fill = "#222222", color = NA),
        panel.background = element_rect(fill = "#222222", color = NA),
        text = element_text(color = "#ffffff"),
        axis.text = element_text(color = "#aaaaaa"),
        panel.grid.major = element_line(color = "#333333"),
        panel.grid.minor = element_blank()
      )
    ggplotly(p, tooltip = c("x", "y")) %>%
      layout(paper_bgcolor = "#222222", plot_bgcolor = "#222222")
  })

  # --- DOW Bar ---
  output$dow_bar <- renderPlotly({
    p <- dow %>%
      mutate(day_of_week_name = fct_reorder(day_of_week_name, day_of_week_num)) %>%
      ggplot(aes(x = day_of_week_name, y = avg_total_rides, fill = day_type_label)) +
      geom_col() +
      scale_fill_manual(values = c(
        "Weekday" = "#00b4d8",
        "Saturday" = "#f4a261",
        "Sunday / Holiday" = "#a8dadc"
      )) +
      scale_y_continuous(labels = scales::comma) +
      labs(x = NULL, y = "Avg Daily Rides", fill = NULL) +
      theme_minimal(base_size = 13) +
      theme(
        plot.background = element_rect(fill = "#222222", color = NA),
        panel.background = element_rect(fill = "#222222", color = NA),
        text = element_text(color = "#ffffff"),
        axis.text = element_text(color = "#aaaaaa"),
        panel.grid.major = element_line(color = "#333333"),
        panel.grid.minor = element_blank(),
        legend.background = element_rect(fill = "#222222", color = NA)
      )
    ggplotly(p, tooltip = c("x", "y")) %>%
      layout(paper_bgcolor = "#222222", plot_bgcolor = "#222222")
  })

  # --- DOW Split ---
  output$dow_split <- renderPlotly({
    p <- dow %>%
      mutate(day_of_week_name = fct_reorder(day_of_week_name, day_of_week_num)) %>%
      select(day_of_week_name, avg_bus_boardings, avg_rail_boardings) %>%
      pivot_longer(cols = c(avg_bus_boardings, avg_rail_boardings),
                   names_to = "mode", values_to = "avg_boardings") %>%
      mutate(mode = recode(mode,
        "avg_bus_boardings" = "Bus",
        "avg_rail_boardings" = "Rail"
      )) %>%
      ggplot(aes(x = day_of_week_name, y = avg_boardings, fill = mode)) +
      geom_col(position = "dodge") +
      scale_fill_manual(values = c("Bus" = "#f4a261", "Rail" = "#00b4d8")) +
      scale_y_continuous(labels = scales::comma) +
      labs(x = NULL, y = "Avg Boardings", fill = NULL) +
      theme_minimal(base_size = 13) +
      theme(
        plot.background = element_rect(fill = "#222222", color = NA),
        panel.background = element_rect(fill = "#222222", color = NA),
        text = element_text(color = "#ffffff"),
        axis.text = element_text(color = "#aaaaaa"),
        panel.grid.major = element_line(color = "#333333"),
        panel.grid.minor = element_blank(),
        legend.background = element_rect(fill = "#222222", color = NA)
      )
    ggplotly(p, tooltip = c("x", "y", "fill")) %>%
      layout(paper_bgcolor = "#222222", plot_bgcolor = "#222222")
  })

}