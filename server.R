library(shiny); library(data.table); library(dplyr)
library(ggplot2); library(markdown); library(plotly)

danger <- fread("./data/danger.csv")
shinyServer(
    function(input, output) {
        output$Plot1 <- renderPlot({
            topHARM <- danger %>%
                transmute(EVTYPE,`TOTAL_HARM, %`= `DEATHS, %`+`INJURIES, %`,
                          `DEATHS, %`,`INJURIES, %`)%>%
                arrange(desc(`TOTAL_HARM, %`))
            if(input$humans == "Deaths Dangers") {
                topH <- topHARM %>%
                    select(EVTYPE, `DEATHS, %`) %>%
                    arrange(desc(`DEATHS, %`)) %>% head(n = 10)
                topH$EVTYPE <- reorder(topH$EVTYPE, topH$`DEATHS, %`)
                gtopH<- topH %>%
                    ggplot(aes(x = EVTYPE, y = `DEATHS, %`)) +
                    geom_bar(stat="identity", fill="firebrick3") +
                    coord_flip() +
                    scale_fill_manual(name="")+
                    xlab("Event Type")+ ylab("Deaths, %")+
                    labs(title ="Top-10 DEATHS DANGERS, %")+
                    theme(plot.title = element_text(size = rel(0.9)),
                          axis.line = element_line(size = 3, colour = "grey80"))
            } else if(input$humans == "Total Harm") {
                topH <- topHARM %>% head(n = 10)
                topH <- melt(select(topH, EVTYPE, `DEATHS, %`,
                                    `INJURIES, %`))
                topH$EVTYPE <- reorder(topH$EVTYPE, topH$value)
                gtopH<- topH %>%
                    ggplot(aes(x = EVTYPE, y = value,
                               fill = variable, order = variable)) +
                    geom_bar(stat="identity") +
                    coord_flip() +
                    scale_fill_manual(
                        name="",values =c("firebrick3","springgreen3"))+
                    xlab("Event Type")+ ylab("Total Harm, %")+
                    labs(title ="Top-10 DANGERS to HUMANS, %")+
                    theme(plot.title = element_text(size = rel(0.9)),
                          axis.line = element_line(size = 3, colour = "grey80"))
            }else {
                topH <- topHARM %>%
                    select(EVTYPE, `INJURIES, %`) %>%
                    arrange(desc(`INJURIES, %`)) %>% head(n = 10)
                topH$EVTYPE <- reorder(topH$EVTYPE, topH$`INJURIES, %`)
                gtopH<- topH %>%
                    ggplot(aes(x = EVTYPE, y = `INJURIES, %`)) +
                    geom_bar(stat="identity", fill="springgreen3") +
                    coord_flip() +
                    scale_fill_manual(name="")+
                    xlab("Event Type")+ ylab("Injuries, %")+
                    labs(title ="Top-10 INJURIES DANGERS, %")+
                    theme(plot.title = element_text(size = rel(0.9)),
                          axis.line = element_line(size = 3, colour = "grey80"))
            }
            print(gtopH)
        })
        output$Plot2 <- renderPlot({
            topDAM <- danger %>%
                transmute(EVTYPE,`TOTAL_DAM, %`= `PROP, %`+`CROP, %`,
                          `PROP, %`,`CROP, %`)%>%
                arrange(desc(`TOTAL_DAM, %`))
            input$action
            isolate(if(input$econ == "Dangers to Property") {
                topD <- topDAM %>%
                    select(EVTYPE, `PROP, %`) %>%
                    arrange(desc(`PROP, %`)) %>% head(n = 10)
                topD$EVTYPE <- reorder(topD$EVTYPE, topD$`PROP, %`)
                topD %>%
                    ggplot(aes(x = EVTYPE, y = `PROP, %`)) +
                    geom_bar(stat="identity", fill="mediumorchid3") +
                    coord_flip() +
                    scale_fill_manual(name="")+
                    xlab("Event Type")+ ylab("Damage to Property, %")+
                    labs(title ="Top-10 DANGERS to PROPERTY, %")+
                    theme(plot.title = element_text(size = rel(0.9)),
                          axis.line = element_line(size = 3, colour = "grey80"))
            } else if(input$econ == "Dangers to Crops") {
                topD <- topDAM %>%
                    select(EVTYPE, `CROP, %`) %>%
                    arrange(desc(`CROP, %`)) %>% head(n = 10)
                topD$EVTYPE <- reorder(topD$EVTYPE, topD$`CROP, %`)
                topD %>%
                    ggplot(aes(x = EVTYPE, y = `CROP, %`)) +
                    geom_bar(stat="identity", fill="darkorange3") +
                    coord_flip() +
                    scale_fill_manual(name="")+
                    xlab("Event Type")+ ylab("Damage to Crops, %")+
                    labs(title ="Top-10 DANGERS to CROPS, %")+
                    theme(plot.title = element_text(size = rel(0.9)),
                          axis.line = element_line(size = 3, colour = "grey80"))
            }else {
                topD <- topDAM %>% head(n = 10)
                topD <- melt(select(topD, EVTYPE, `PROP, %`, `CROP, %`))
                topD$EVTYPE <- reorder(topD$EVTYPE, topD$value)
                topD %>%
                    ggplot(aes(x = EVTYPE, y = value, fill = variable, order = variable)) +
                    geom_bar(stat="identity") +
                    coord_flip() +
                    scale_fill_manual(name="", values =
                                          c("darkorange3","mediumorchid3"))+
                    xlab("Event Type")+ ylab("Total Damage, %")+
                    labs(title ="Top-10 DANGERS to ECONOMICS, %")+
                    theme(plot.title = element_text(size = rel(0.9)),
                          axis.line = element_line(size = 3, colour = "grey80"))                                }
            )
        })
        harm <- reactive({
            danger %>%
                arrange(desc(`DEATHS, %`+`INJURIES, %`)) %>%
                transmute(rank = row_number(), EVTYPE,
                          `TOTAL_HARM, %`= `DEATHS, %`+`INJURIES, %`,
                          `DEATHS, %`,`INJURIES, %`)
            
        })     
        output$Table1 <- renderTable({
            if(input$HarmtoHumans == "Top-10") {
                harm() %>%  head(n = 10)
            } else if(input$HarmtoHumans == "Top-20") {
                harm() %>%  head(n = 20)
            }else {
                harm()
            }
        })
        dam <- reactive({
            danger %>% arrange(desc(`PROP, %`+`CROP, %`)) %>%
                transmute(rank = row_number(), EVTYPE,
                          `TOTAL_DAM, %`= `PROP, %`+`CROP, %`,
                          `PROP, %`,`CROP, %`)
        })
        output$Table2 <- renderTable({
            if(input$DamagetoEconomics == "Top-10") {
                dam() %>%  head(n = 10)
            } else if(input$DamagetoEconomics == "Top-20") {
                dam() %>%  head(n = 20)
            }else {
                dam()
            }
        })
    })
