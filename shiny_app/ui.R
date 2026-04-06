ui <- page_navbar(
  title = "CTA Ridership Analytics",
  theme = bs_theme(
    bootswatch = "darkly",
    primary = "#00b4d8",
    base_font = font_google("Inter")
  ),

  # Tab 1 - Monthly Trend
nav_panel(
    title = "Monthly Trends",
    layout_columns(
      col_widths = c(12),
      card(
        card_header("Filters"),
        sliderInput(
          inputId = "year_range",
          label = "Select Year Range",
          min = 2001,
          max = 2026,
          value = c(2001, 2026),
          step = 1,
          sep = ""
        )
      )
    ),
    layout_columns(
      col_widths = c(12),
      card(
        card_header("System-Wide Monthly Ridership"),
        plotlyOutput("monthly_trend", height = "450px")
      )
    ),
    layout_columns(
      col_widths = c(6, 6),
      card(
        card_header("Bus vs Rail Boardings Over Time"),
        plotlyOutput("bus_vs_rail", height = "350px")
      ),
      card(
        card_header("Rail Share of Total Rides (%)"),
        plotlyOutput("rail_share", height = "350px")
      )
    )
  ),

  # Tab 2 - Day of Week
  nav_panel(
    title = "Day of Week Patterns",
    layout_columns(
      col_widths = c(6, 6),
      card(
        card_header("Average Daily Rides by Day of Week"),
        plotlyOutput("dow_bar", height = "400px")
      ),
      card(
        card_header("Bus vs Rail by Day of Week"),
        plotlyOutput("dow_split", height = "400px")
      )
    )
  )
)