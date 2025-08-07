<group>
                            <field name="clicks_count"/>
                            <field name="keystrokes_count"/>
                        </group>
                        <group>
                            <field name="was_saved"/>
                            <field name="was_cancelled"/>
                            <field name="had_validation_errors"/>
                        </group>
                    </group>
                    <group string="Campos Modificados" invisible="not fields_modified">
                        <field name="fields_modified" colspan="2"/>
                    </group>
                    <group string="Errores" invisible="not error_messages">
                        <field name="error_messages" colspan="2"/>
                    </group>
                </sheet>
            </form>
        </field>
    </record>

    <!-- Form Session Search View -->
    <record id="view_form_session_search" model="ir.ui.view">
        <field name="name">hexagonos.form.session.search</field>
        <field name="model">hexagonos.form.session</field>
        <field name="arch" type="xml">
            <search>
                <field name="user_id"/>
                <field name="model_name"/>
                <field name="model_display_name"/>
                <separator/>
                <filter string="Guardados" name="saved" domain="[('was_saved', '=', True)]"/>
                <filter string="Cancelados" name="cancelled" domain="[('was_cancelled', '=', True)]"/>
                <filter string="Con Errores" name="errors" domain="[('had_validation_errors', '=', True)]"/>
                <separator/>
                <filter string="Crear" name="create_forms" domain="[('form_type', '=', 'create')]"/>
                <filter string="Editar" name="edit_forms" domain="[('form_type', '=', 'edit')]"/>
                <filter string="Ver" name="view_forms" domain="[('form_type', '=', 'view')]"/>
                <separator/>
                <filter string="Hoy" name="today" domain="[('start_time', '>=', (context_today()).strftime('%Y-%m-%d 00:00:00'))]"/>
                <filter string="Esta Semana" name="this_week" domain="[('start_time', '>=', (context_today() - datetime.timedelta(days=context_today().weekday())).strftime('%Y-%m-%d 00:00:00'))]"/>
                <separator/>
                <group expand="0" string="Agrupar Por">
                    <filter string="Usuario" name="group_by_user" context="{'group_by': 'user_id'}"/>
                    <filter string="Modelo" name="group_by_model" context="{'group_by': 'model_display_name'}"/>
                    <filter string="Tipo" name="group_by_type" context="{'group_by': 'form_type'}"/>
                    <filter string="Fecha" name="group_by_date" context="{'group_by': 'start_time:day'}"/>
                </group>
            </search>
        </field>
    </record>

    <!-- Action -->
    <record id="action_form_session" model="ir.actions.act_window">
        <field name="name">Sesiones de Formulario</field>
        <field name="res_model">hexagonos.form.session</field>
        <field name="view_mode">tree,form</field>
        <field name="context">{'search_default_today': 1}</field>
        <field name="help" type="html">
            <p class="o_view_nocontent_smiling_face">
                No hay sesiones de formulario registradas
            </p>
            <p>
                Las sesiones de formulario se rastrean automáticamente cuando los usuarios interactúan con formularios.
            </p>
        </field>
    </record>
EOF

# Views - Productivity Metrics
cat > "$MODULE_PATH/views/productivity_views.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <!-- Productivity Metrics Tree View -->
    <record id="view_productivity_metrics_tree" model="ir.ui.view">
        <field name="name">hexagonos.productivity.metrics.tree</field>
        <field name="model">hexagonos.productivity.metrics</field>
        <field name="arch" type="xml">
            <tree string="Métricas de Productividad" decoration-success="efficiency_score >= 8" decoration-warning="efficiency_score >= 5 and efficiency_score &lt; 8" decoration-danger="efficiency_score &lt; 5">
                <field name="user_id"/>
                <field name="date"/>
                <field name="total_session_time_hours" widget="float_time"/>
                <field name="active_time_hours" widget="float_time"/>
                <field name="records_created"/>
                <field name="records_edited"/>
                <field name="success_rate_percentage" widget="percentage"/>
                <field name="efficiency_score"/>
                <field name="vs_yesterday_efficiency" widget="percentage"/>
            </tree>
        </field>
    </record>

    <!-- Productivity Metrics Form View -->
    <record id="view_productivity_metrics_form" model="ir.ui.view">
        <field name="name">hexagonos.productivity.metrics.form</field>
        <field name="model">hexagonos.productivity.metrics</field>
        <field name="arch" type="xml">
            <form string="Métricas de Productividad" create="false" edit="false">
                <sheet>
                    <div class="oe_title">
                        <h1>
                            <field name="metric_display"/>
                        </h1>
                    </div>
                    <group>
                        <group string="Información General">
                            <field name="user_id"/>
                            <field name="date"/>
                            <field name="efficiency_score"/>
                        </group>
                        <group string="Comparativas">
                            <field name="vs_yesterday_efficiency" widget="percentage"/>
                            <field name="vs_week_avg_efficiency" widget="percentage"/>
                        </group>
                    </group>
                    <group string="Métricas de Tiempo">
                        <group>
                            <field name="total_session_time_hours" widget="float_time"/>
                            <field name="active_time_hours" widget="float_time"/>
                            <field name="idle_time_hours" widget="float_time"/>
                        </group>
                        <group>
                            <field name="avg_form_completion_time" widget="float_time"/>
                            <field name="success_rate_percentage" widget="percentage"/>
                        </group>
                    </group>
                    <group string="Métricas de Productividad">
                        <group>
                            <field name="records_created"/>
                            <field name="records_edited"/>
                            <field name="records_viewed"/>
                        </group>
                        <group>
                            <field name="forms_completed"/>
                            <field name="forms_cancelled"/>
                            <field name="unique_models_used"/>
                        </group>
                    </group>
                    <group string="Métricas de Interacción">
                        <group>
                            <field name="total_clicks"/>
                            <field name="total_keystrokes"/>
                            <field name="pages_visited"/>
                        </group>
                    </group>
                </sheet>
            </form>
        </field>
    </record>

    <!-- Productivity Metrics Pivot View -->
    <record id="view_productivity_metrics_pivot" model="ir.ui.view">
        <field name="name">hexagonos.productivity.metrics.pivot</field>
        <field name="model">hexagonos.productivity.metrics</field>
        <field name="arch" type="xml">
            <pivot string="Análisis de Productividad">
                <field name="user_id" type="row"/>
                <field name="date" type="col" interval="day"/>
                <field name="efficiency_score" type="measure"/>
                <field name="active_time_hours" type="measure"/>
                <field name="records_created" type="measure"/>
                <field name="records_edited" type="measure"/>
                <field name="success_rate_percentage" type="measure"/>
            </pivot>
        </field>
    </record>

    <!-- Productivity Metrics Graph View -->
    <record id="view_productivity_metrics_graph" model="ir.ui.view">
        <field name="name">hexagonos.productivity.metrics.graph</field>
        <field name="model">hexagonos.productivity.metrics</field>
        <field name="arch" type="xml">
            <graph string="Tendencias de Productividad" type="line">
                <field name="date" type="row" interval="day"/>
                <field name="efficiency_score" type="measure"/>
            </graph>
        </field>
    </record>

    <!-- Productivity Metrics Search View -->
    <record id="view_productivity_metrics_search" model="ir.ui.view">
        <field name="name">hexagonos.productivity.metrics.search</field>
        <field name="model">hexagonos.productivity.metrics</field>
        <field name="arch" type="xml">
            <search>
                <field name="user_id"/>
                <field name="date"/>
                <separator/>
                <filter string="Alta Eficiencia" name="high_efficiency" domain="[('efficiency_score', '>=', 8)]"/>
                <filter string="Eficiencia Media" name="medium_efficiency" domain="[('efficiency_score', '>=', 5), ('efficiency_score', '&lt;', 8)]"/>
                <filter string="Baja Eficiencia" name="low_efficiency" domain="[('efficiency_score', '&lt;', 5)]"/>
                <separator/>
                <filter string="Hoy" name="today" domain="[('date', '=', context_today())]"/>
                <filter string="Esta Semana" name="this_week" domain="[('date', '>=', (context_today() - datetime.timedelta(days=context_today().weekday())).strftime('%Y-%m-%d')), ('date', '&lt;=', context_today())]"/>
                <filter string="Este Mes" name="this_month" domain="[('date', '>=', (context_today().replace(day=1)).strftime('%Y-%m-%d')), ('date', '&lt;=', context_today())]"/>
                <separator/>
                <group expand="0" string="Agrupar Por">
                    <filter string="Usuario" name="group_by_user" context="{'group_by': 'user_id'}"/>
                    <filter string="Fecha" name="group_by_date" context="{'group_by': 'date'}"/>
                </group>
            </search>
        </field>
    </record>

    <!-- Action -->
    <record id="action_productivity_metrics" model="ir.actions.act_window">
        <field name="name">Métricas de Productividad</field>
        <field name="res_model">hexagonos.productivity.metrics</field>
        <field name="view_mode">tree,form,pivot,graph</field>
        <field name="context">{'search_default_this_week': 1}</field>
        <field name="help" type="html">
            <p class="o_view_nocontent_smiling_face">
                No hay métricas de productividad calculadas
            </p>
            <p>
                Las métricas se calculan automáticamente basadas en la actividad de los usuarios.
            </p>
        </field>
    </record>
EOF

# Views - Analytics Dashboard
cat > "$MODULE_PATH/views/analytics_dashboard_views.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <!-- Analytics Dashboard View -->
    <record id="view_analytics_dashboard_form" model="ir.ui.view">
        <field name="name">hexagonos.analytics.dashboard.form</field>
        <field name="model">hexagonos.analytics.dashboard</field>
        <field name="arch" type="xml">
            <form string="Dashboard de Analytics">
                <header>
                    <button name="%(action_generate_analytics_report)d" string="Generar Reporte" type="action" class="btn-primary"/>
                    <button name="calculate_daily_metrics" string="Calcular Métricas" type="object" class="btn-secondary"/>
                </header>
                <sheet>
                    <div class="oe_title">
                        <h1>📊 Dashboard de User Analytics</h1>
                    </div>
                    <group string="Filtros">
                        <group>
                            <field name="date_from"/>
                            <field name="date_to"/>
                        </group>
                        <group>
                            <field name="user_ids" widget="many2many_tags"/>
                            <field name="department_ids" widget="many2many_tags"/>
                        </group>
                    </group>
                    
                    <!-- Dashboard Container -->
                    <div class="o_hexagonos_dashboard">
                        <div id="hexagonosMainDashboard" class="o_analytics_dashboard">
                            <!-- El dashboard se renderiza aquí via JavaScript -->
                        </div>
                    </div>
                </sheet>
            </form>
        </field>
    </record>

    <!-- Dashboard Action -->
    <record id="action_analytics_dashboard" model="ir.actions.act_window">
        <field name="name">Dashboard Analytics</field>
        <field name="res_model">hexagonos.analytics.dashboard</field>
        <field name="view_mode">form</field>
        <field name="view_id" ref="view_analytics_dashboard_form"/>
        <field name="target">current</field>
        <field name="context">{}</field>
    </record>

    <!-- Dashboard Method -->
    <record id="dashboard_calculate_daily_metrics" model="ir.actions.server">
        <field name="name">Calcular Métricas Diarias</field>
        <field name="model_id" ref="model_hexagonos_analytics_dashboard"/>
        <field name="binding_model_id" ref="model_hexagonos_analytics_dashboard"/>
        <field name="state">code</field>
        <field name="code">
# Calcular métricas para todos los usuarios activos
users = env['res.users'].search([('active', '=', True)])
metrics_model = env['hexagonos.productivity.metrics']

for user in users:
    try:
        metrics_model.calculate_daily_metrics(user.id)
    except Exception as e:
        _logger.warning(f"Error calculando métricas para usuario {user.name}: {str(e)}")

action = {
    'type': 'ir.actions.client',
    'tag': 'display_notification',
    'params': {
        'title': 'Métricas Calculadas',
        'message': f'Métricas actualizadas para {len(users)} usuarios',
        'type': 'success',
    }
}
        </field>
    </record>
EOF

# Views - Menu
cat > "$MODULE_PATH/views/menu_views.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <!-- Main Menu -->
    <menuitem id="menu_hexagonos_analytics_root" 
              name="Analytics" 
              sequence="5" 
              web_icon="hexagonos_analytics,static/description/icon.png"/>

    <!-- Dashboard Menu -->
    <menuitem id="menu_analytics_dashboard"
              name="Dashboard"
              parent="menu_hexagonos_analytics_root"
              action="action_analytics_dashboard"
              sequence="1"/>

    <!-- Reports Menu -->
    <menuitem id="menu_analytics_reports"
              name="Reportes"
              parent="menu_hexagonos_analytics_root"
              sequence="2"/>

    <!-- User Sessions Menu -->
    <menuitem id="menu_user_sessions"
              name="Sesiones de Usuario"
              parent="menu_analytics_reports"
              action="action_user_session"
              sequence="1"/>

    <!-- Form Sessions Menu -->
    <menuitem id="menu_form_sessions"
              name="Sesiones de Formulario"
              parent="menu_analytics_reports"
              action="action_form_session"
              sequence="2"/>

    <!-- Productivity Metrics Menu -->
    <menuitem id="menu_productivity_metrics"
              name="Métricas de Productividad"
              parent="menu_analytics_reports"
              action="action_productivity_metrics"
              sequence="3"/>

    <!-- Configuration Menu -->
    <menuitem id="menu_analytics_config"
              name="Configuración"
              parent="menu_hexagonos_analytics_root"
              sequence="9"
              groups="hexagonos_analytics.group_analytics_manager"/>
EOF

# 12. WIZARD
echo "📝 Creando wizard/analytics_report_wizard.py..."
cat > "$MODULE_PATH/wizard/analytics_report_wizard.py" << 'EOF'
# -*- coding: utf-8 -*-
from odoo import models, fields, api
from datetime import datetime, timedelta
import base64
import io
import csv
import json
import logging

_logger = logging.getLogger(__name__)

class AnalyticsReportWizard(models.TransientModel):
    _name = 'hexagonos.analytics.report.wizard'
    _description = 'Analytics Report Generator'

    # Filtros de reporte
    date_from = fields.Date(string='Fecha Desde', default=lambda self: fields.Date.today() - timedelta(days=30), required=True)
    date_to = fields.Date(string='Fecha Hasta', default=fields.Date.today, required=True)
    user_ids = fields.Many2many('res.users', string='Usuarios')
    department_ids = fields.Many2many('hr.department', string='Departamentos')
    
    # Tipo de reporte
    report_type = fields.Selection([
        ('summary', 'Resumen Ejecutivo'),
        ('detailed', 'Reporte Detallado'),
        ('productivity', 'Análisis de Productividad'),
        ('forms_analysis', 'Análisis de Formularios'),
        ('time_tracking', 'Seguimiento de Tiempo'),
    ], string='Tipo de Reporte', default='summary', required=True)
    
    # Formato de salida
    output_format = fields.Selection([
        ('pdf', 'PDF'),
        ('xlsx', 'Excel'),
        ('csv', 'CSV'),
        ('json', 'JSON'),
    ], string='Formato de Salida', default='pdf', required=True)
    
    # Incluir gráficas
    include_charts = fields.Boolean(string='Incluir Gráficas', default=True)
    
    @api.model
    def default_get(self, fields_list):
        result = super().default_get(fields_list)
        # Si estamos en el contexto de un usuario específico, incluirlo
        if self.env.context.get('active_model') == 'res.users':
            active_ids = self.env.context.get('active_ids', [])
            if active_ids:
                result['user_ids'] = [(6, 0, active_ids)]
        return result
    
    def generate_report(self):
        """Generar el reporte según los parámetros seleccionados"""
        try:
            # Obtener datos
            data = self._get_report_data()
            
            # Generar según formato
            if self.output_format == 'pdf':
                return self._generate_pdf_report(data)
            elif self.output_format == 'xlsx':
                return self._generate_excel_report(data)
            elif self.output_format == 'csv':
                return self._generate_csv_report(data)
            elif self.output_format == 'json':
                return self._generate_json_report(data)
                
        except Exception as e:
            _logger.error(f"Error generando reporte: {str(e)}")
            raise models.UserError(f"Error al generar el reporte: {str(e)}")
    
    def _get_report_data(self):
        """Obtener datos para el reporte"""
        dashboard_model = self.env['hexagonos.analytics.dashboard']
        
        filters = {
            'date_from': self.date_from,
            'date_to': self.date_to,
            'user_ids': self.user_ids.ids if self.user_ids else [],
            'department_ids': self.department_ids.ids if self.department_ids else [],
        }
        
        return dashboard_model.get_dashboard_data(filters)
    
    def _generate_pdf_report(self, data):
        """Generar reporte PDF"""
        report_name = f"analytics_report_{self.report_type}_{self.date_from}_{self.date_to}.pdf"
        
        # Por ahora retornar acción para mostrar datos
        # En implementación completa, usar reportlab o similar
        return {
            'type': 'ir.actions.act_window',
            'res_model': 'hexagonos.analytics.report.wizard',
            'view_mode': 'form',
            'view_id': self.env.ref('hexagonos_analytics.view_analytics_report_result').id,
            'target': 'new',
            'context': {
                'default_report_data': json.dumps(data),
                'default_report_name': report_name,
            }
        }
    
    def _generate_excel_report(self, data):
        """Generar reporte Excel"""
        try:
            output = io.BytesIO()
            
            # Crear archivo CSV (simplificado)
            # En implementación completa, usar openpyxl
            csv_content = self._format_data_as_csv(data)
            output.write(csv_content.encode('utf-8'))
            output.seek(0)
            
            report_name = f"analytics_report_{self.report_type}_{self.date_from}_{self.date_to}.csv"
            
            attachment = self.env['ir.attachment'].create({
                'name': report_name,
                'type': 'binary',
                'datas': base64.b64encode(output.read()),
                'res_model': 'hexagonos.analytics.report.wizard',
                'res_id': self.id,
                'mimetype': 'text/csv',
            })
            
            return {
                'type': 'ir.actions.act_url',
                'url': f'/web/content/{attachment.id}?download=true',
                'target': 'new',
            }
            
        except Exception as e:
            _logger.error(f"Error generando Excel: {str(e)}")
            raise models.UserError(f"Error generando archivo Excel: {str(e)}")
    
    def _generate_csv_report(self, data):
        """Generar reporte CSV"""
        csv_content = self._format_data_as_csv(data)
        report_name = f"analytics_report_{self.report_type}_{self.date_from}_{self.date_to}.csv"
        
        attachment = self.env['ir.attachment'].create({
            'name': report_name,
            'type': 'binary',
            'datas': base64.b64encode(csv_content.encode('utf-8')),
            'res_model': 'hexagonos.analytics.report.wizard',
            'res_id': self.id,
            'mimetype': 'text/csv',
        })
        
        return {
            'type': 'ir.actions.act_url',
            'url': f'/web/content/{attachment.id}?download=true',
            'target': 'new',
        }
    
    def _generate_json_report(self, data):
        """Generar reporte JSON"""
        json_content = json.dumps(data, indent=2, default=str)
        report_name = f"analytics_report_{self.report_type}_{self.date_from}_{self.date_to}.json"
        
        attachment = self.env['ir.attachment'].create({
            'name': report_name,
            'type': 'binary',
            'datas': base64.b64encode(json_content.encode('utf-8')),
            'res_model': 'hexagonos.analytics.report.wizard',
            'res_id': self.id,
            'mimetype': 'application/json',
        })
        
        return {
            'type': 'ir.actions.act_url',
            'url': f'/web/content/{attachment.id}?download=true',
            'target': 'new',
        }
    
    def _format_data_as_csv(self, data):
        """Formatear datos como CSV"""
        output = io.StringIO()
        writer = csv.writer(output)
        
        # Header
        writer.writerow(['Reporte de Analytics', f'Del {self.date_from} al {self.date_to}'])
        writer.writerow([])
        
        # Summary metrics
        if 'summary_metrics' in data:
            writer.writerow(['=== MÉTRICAS GENERALES ==='])
            metrics = data['summary_metrics']
            for key, value in metrics.items():
                writer.writerow([key.replace('_', ' ').title(), value])
            writer.writerow([])
        
        # User ranking
        if 'user_ranking' in data:
            writer.writerow(['=== RANKING DE USUARIOS ==='])
            writer.writerow(['Posición', 'Usuario', 'Eficiencia', 'Acciones', 'Tiempo Activo', 'Tasa Éxito'])
            for user in data['user_ranking']:
                writer.writerow([
                    user.get('rank', ''),
                    user.get('user_name', ''),
                    user.get('efficiency_score', ''),
                    user.get('total_actions', ''),
                    user.get('active_time', ''),
                    user.get('success_rate', ''),
                ])
            writer.writerow([])
        
        # Model usage
        if 'model_usage' in data:
            writer.writerow(['=== USO DE MODELOS ==='])
            writer.writerow(['Modelo', 'Uso Total', 'Tiempo Promedio (seg)'])
            for model in data['model_usage']:
                writer.writerow([
                    model.get('model', ''),
                    model.get('usage_count', ''),
                    model.get('avg_time_seconds', ''),
                ])
            writer.writerow([])
        
        return output.getvalue()
EOF

# Wizard Views
cat > "$MODULE_PATH/wizard/analytics_report_wizard_views.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <!-- Report Wizard Form -->
    <record id="view_analytics_report_wizard" model="ir.ui.view">
        <field name="name">hexagonos.analytics.report.wizard.form</field>
        <field name="model">hexagonos.analytics.report.wizard</field>
        <field name="arch" type="xml">
            <form string="Generar Reporte de Analytics">
                <group string="Período">
                    <group>
                        <field name="date_from"/>
                        <field name="date_to"/>
                    </group>
                    <group>
                        <field name="user_ids" widget="many2many_tags"/>
                        <field name="department_ids" widget="many2many_tags"/>
                    </group>
                </group>
                <group string="Configuración del Reporte">
                    <group>
                        <field name="report_type"/>
                        <field name="output_format"/>
                    </group>
                    <group>
                        <field name="include_charts"/>
                    </group>
                </group>
                <footer>
                    <button name="generate_report" string="Generar Reporte" type="object" class="btn-primary"/>
                    <button string="Cancelar" class="btn-secondary" special="cancel"/>
                </footer>
            </form>
        </field>
    </record>

    <!-- Report Result View -->
    <record id="view_analytics_report_result" model="ir.ui.view">
        <field name="name">hexagonos.analytics.report.result</field>
        <field name="model">hexagonos.analytics.report.wizard</field>
        <field name="arch" type="xml">
            <form string="Resultado del Reporte" create="false" edit="false">
                <div class="alert alert-success">
                    <h4>✅ Reporte Generado Exitosamente</h4>
                    <p>El reporte ha sido generado y está listo para descargar.</p>
                </div>
                <footer>
                    <button string="Cerrar" class="btn-primary" special="cancel"/>
                </footer>
            </form>
        </field>
    </record>

    <!-- Wizard Action -->
    <record id="action_generate_analytics_report" model="ir.actions.act_window">
        <field name="name">Generar Reporte de Analytics</field>
        <field name="res_model">hexagonos.analytics.report.wizard</field>
        <field name="view_mode">form</field>
        <field name="view_id" ref="view_analytics_report_wizard"/>
        <field name="target">new</field>
    </record>
EOF

# 13. DATOS INICIALES
echo "📝 Creando data/analytics_data.xml..."
cat > "$MODULE_PATH/data/analytics_data.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <data noupdate="1">
        
        <!-- Cron Job: Calcular métricas diarias -->
        <record id="cron_calculate_daily_metrics" model="ir.cron">
            <field name="name">Analytics: Calcular Métricas Diarias</field>
            <field name="model_id" ref="model_hexagonos_productivity_metrics"/>
            <field name="state">code</field>
            <field name="code">
# Calcular métricas diarias para todos los usuarios
users = env['res.users'].search([('active', '=', True)])
for user in users:
    try:
        model.calculate_daily_metrics(user.id)
    except Exception as e:
        pass  # Log error but continue
            </field>
            <field name="interval_number">1</field>
            <field name="interval_type">days</field>
            <field name="nextcall" eval="(DateTime.now() + timedelta(days=1)).replace(hour=1, minute=0, second=0)"/>
            <field name="active" eval="True"/>
        </record>
        
        <!-- Cron Job: Limpiar sesiones antiguas -->
        <record id="cron_cleanup_old_sessions" model="ir.cron">
            <field name="name">Analytics: Limpiar Sesiones Antiguas</field>
            <field name="model_id" ref="model_hexagonos_user_session"/>
            <field name="state">code</field>
            <field name="code">
# Limpiar sesiones de más de 90 días
cutoff_date = fields.Datetime.now() - timedelta(days=90)
old_sessions = model.search([('login_time', '&lt;', cutoff_date)])
old_sessions.unlink()

# Limpiar formularios de más de 90 días  
form_model = env['hexagonos.form.session']
old_forms = form_model.search([('start_time', '&lt;', cutoff_date)])
old_forms.unlink()

# Limpiar métricas de más de 1 año
metrics_cutoff = fields.Date.today() - timedelta(days=365)
metrics_model = env['hexagonos.productivity.metrics']
old_metrics = metrics_model.search([('date', '&lt;', metrics_cutoff)])
old_metrics.unlink()
            </field>
            <field name="interval_number">1</field>
            <field name="interval_type">weeks</field>
            <field name="nextcall" eval="(DateTime.now() + timedelta(days=7)).replace(hour=2, minute=0, second=0)"/>
            <field name="active" eval="True"/>
        </record>
        
        <!-- Configuración por defecto -->
        <record id="config_analytics_default" model="ir.config_parameter">
            <field name="key">hexagonos_analytics.tracking_enabled</field>
            <field name="value">True</field>
        </record>
        
        <record id="config_analytics_idle_timeout" model="ir.config_parameter">
            <field name="key">hexagonos_analytics.idle_timeout_minutes</field>
            <field name="value">5</field>
        </record>
        
        <record id="config_analytics_batch_size" model="ir.config_parameter">
            <field name="key">hexagonos_analytics.batch_size</field>
            <field name="value">50</field>
        </record>
        
    </data>
</odoo>
EOF

# 14. FINALIZACIÓN
echo "🎨 Creando icono del módulo..."
mkdir -p "$MODULE_PATH/static/description"

# Crear un icono simple con texto
cat > "$MODULE_PATH/static/description/icon.png.txt" << 'EOF'
# Para el icono, necesitas crear un archivo PNG de 128x128px
# Puedes usar cualquier herramienta de diseño o un placeholder
# El archivo debe llamarse: icon.png
EOF

# README
cat > "$MODULE_PATH/README.md" << 'EOF'
# Hexagonos User Analytics

## Descripción
Módulo avanzado de analytics de usuario para Odoo 18 que rastrea y analiza el comportamiento de los usuarios en tiempo real.

## Características
- 📊 Tracking automático de todas las interacciones de usuario
- ⏱️ Medición de tiempo exacto en formularios
- 📈 Dashboards en tiempo real con gráficas nativas
- 🎯 Métricas de productividad y eficiencia
- 🔍 Análisis detallado de patrones de uso
- 📱 Compatible con todos los módulos de Odoo
- 🚀 Sin dependencias externas

## Instalación
1. Copiar el módulo a la carpeta addons
2. Actualizar lista de módulos
3. Instalar "Hexagonos User Analytics"

## Uso
1. El tracking se activa automáticamente al instalar
2. Acceder a Analytics > Dashboard para ver métricas
3. Configurar usuarios y permisos según necesidad
4. Generar reportes personalizados

## Soporte
Desarrollado por Hexagonos Team
EOF

# Crear directorio de logs si no existe
mkdir -p ./logs

echo ""
echo "🎉 ¡Módulo Hexagonos Analytics generado exitosamente!"
echo ""
echo "📁 Ubicación: $MODULE_PATH"
echo ""
echo "🚀 Próximos pasos:"
echo "1. Verificar que el directorio addons esté montado en Docker"
echo "2. Reiniciar Odoo: docker compose restart web"
echo "3. Actualizar lista de módulos en Odoo"
echo "4. Instalar el módulo 'Hexagonos User Analytics'"
echo "5. Configurar permisos de usuario"
echo ""
echo "🔧 Comandos útiles:"
echo "   docker compose exec web odoo --config=/etc/odoo/odoo.conf -d tu_bd -i hexagonos_analytics"
echo "   docker compose logs -f web"
echo ""
echo "📊 Acceso al Dashboard:"
echo "   Odoo > Analytics > Dashboard"
echo ""
echo "✅ El módulo incluye:"
echo "   - Tracking automático universal"
echo "   - Gráficas nativas (sin Chart.js/D3)"
echo "   - Dashboard en tiempo real"
echo "   - Reportes exportables"
echo "   - Sistema de permisos"
echo "   - APIs REST"
echo "   - Cron jobs automáticos"
echo ""

# Hacer ejecutables los scripts
chmod +x "$0"

echo "🎯 ¡Listo para capturar cada click de tus usuarios!"
EOF

# Hacer el script ejecutable
chmod +x "$MODULE_PATH/../../../app.sh"

echo ""
echo "🎉 ¡Script app.sh generado exitosamente!"
echo ""
echo "🚀 Para generar el módulo ejecuta:"
echo "   ./app.sh"
echo ""
echo "📁 El módulo se creará en: ./addons/hexagonos_analytics/"
echo ""#!/bin/bash

# app.sh - Generador de Módulo Hexagonos Analytics para Odoo 18
# Autor: Hexagonos Team
# Versión: 1.0

set -e

MODULE_NAME="hexagonos_analytics"
MODULE_PATH="./addons/$MODULE_NAME"

echo "🚀 Generando módulo Hexagonos Analytics para Odoo 18..."
echo "📁 Ruta: $MODULE_PATH"

# Crear estructura de directorios
echo "📂 Creando estructura de directorios..."
mkdir -p "$MODULE_PATH"/{models,views,controllers,static/src/{js,css},security,wizard,report,data}

# 1. MANIFEST
echo "📝 Creando __manifest__.py..."
cat > "$MODULE_PATH/__manifest__.py" << 'EOF'
# -*- coding: utf-8 -*-
{
    'name': 'Hexagonos User Analytics',
    'version': '18.0.1.0.0',
    'category': 'Analytics/Business Intelligence',
    'summary': 'Advanced user behavior tracking and productivity analytics',
    'description': '''
    Hexagonos User Analytics
    =======================
    
    Track and analyze user behavior in real-time:
    • Time spent on forms and views
    • User productivity metrics  
    • Session analytics with detailed breakdowns
    • Click patterns and interaction heatmaps
    • Performance bottleneck identification
    • Real-time dashboards with native charts
    • Predictive analytics and alerts
    
    Compatible with ALL Odoo modules automatically.
    ''',
    'author': 'Hexagonos',
    'website': 'https://hexagonos.com',
    'depends': ['base', 'web'],
    'data': [
        'security/security.xml',
        'security/ir.model.access.csv',
        'data/analytics_data.xml',
        'views/user_session_views.xml',
        'views/form_session_views.xml',
        'views/productivity_views.xml',
        'views/analytics_dashboard_views.xml',
        'views/menu_views.xml',
        'wizard/analytics_report_wizard_views.xml',
    ],
    'assets': {
        'web.assets_backend': [
            'hexagonos_analytics/static/src/js/user_tracker.js',
            'hexagonos_analytics/static/src/js/form_tracker.js',
            'hexagonos_analytics/static/src/js/chart_engine.js',
            'hexagonos_analytics/static/src/js/dashboard_controller.js',
            'hexagonos_analytics/static/src/css/analytics_styles.css',
        ],
    },
    'demo': [],
    'installable': True,
    'auto_install': False,
    'application': True,
    'license': 'LGPL-3',
}
EOF

# 2. INIT FILES
echo "📝 Creando archivos __init__.py..."
cat > "$MODULE_PATH/__init__.py" << 'EOF'
# -*- coding: utf-8 -*-
from . import models
from . import controllers
from . import wizard
EOF

cat > "$MODULE_PATH/models/__init__.py" << 'EOF'
# -*- coding: utf-8 -*-
from . import user_session
from . import form_session
from . import productivity_metrics
from . import analytics_dashboard
EOF

cat > "$MODULE_PATH/controllers/__init__.py" << 'EOF'
# -*- coding: utf-8 -*-
from . import analytics_controller
EOF

cat > "$MODULE_PATH/wizard/__init__.py" << 'EOF'
# -*- coding: utf-8 -*-
from . import analytics_report_wizard
EOF

# 3. MODELOS PRINCIPALES
echo "📝 Creando models/user_session.py..."
cat > "$MODULE_PATH/models/user_session.py" << 'EOF'
# -*- coding: utf-8 -*-
from odoo import models, fields, api
from datetime import datetime, timedelta
import json
import logging

_logger = logging.getLogger(__name__)

class UserSession(models.Model):
    _name = 'hexagonos.user.session'
    _description = 'User Session Tracking'
    _order = 'login_time desc'
    _rec_name = 'session_display'

    # Información básica de sesión
    user_id = fields.Many2one('res.users', string='Usuario', required=True, ondelete='cascade')
    session_id = fields.Char(string='Session ID', required=True, index=True)
    login_time = fields.Datetime(string='Hora Login', default=fields.Datetime.now, required=True)
    logout_time = fields.Datetime(string='Hora Logout')
    
    # Métricas de tiempo
    duration_hours = fields.Float(string='Duración (horas)', compute='_compute_duration', store=True)
    active_time_minutes = fields.Float(string='Tiempo Activo (min)', default=0)
    idle_time_minutes = fields.Float(string='Tiempo Inactivo (min)', default=0)
    
    # Información técnica
    ip_address = fields.Char(string='Dirección IP')
    user_agent = fields.Text(string='User Agent')
    browser_info = fields.Text(string='Info Navegador')
    
    # Contadores de actividad
    pages_visited = fields.Integer(string='Páginas Visitadas', default=0)
    clicks_total = fields.Integer(string='Total Clicks', default=0)
    keystrokes_total = fields.Integer(string='Total Teclas', default=0)
    forms_opened = fields.Integer(string='Formularios Abiertos', default=0)
    records_created = fields.Integer(string='Registros Creados', default=0)
    records_edited = fields.Integer(string='Registros Editados', default=0)
    
    # Estado de sesión
    is_active = fields.Boolean(string='Sesión Activa', default=True)
    last_activity = fields.Datetime(string='Última Actividad', default=fields.Datetime.now)
    
    # Campo calculado para display
    session_display = fields.Char(string='Sesión', compute='_compute_session_display')
    
    @api.depends('user_id', 'login_time')
    def _compute_session_display(self):
        for record in self:
            if record.user_id and record.login_time:
                record.session_display = f"{record.user_id.name} - {record.login_time.strftime('%d/%m/%Y %H:%M')}"
            else:
                record.session_display = "Sesión sin identificar"
    
    @api.depends('login_time', 'logout_time')
    def _compute_duration(self):
        for record in self:
            if record.login_time:
                end_time = record.logout_time or fields.Datetime.now()
                delta = end_time - record.login_time
                record.duration_hours = delta.total_seconds() / 3600
            else:
                record.duration_hours = 0
    
    @api.model
    def create_session(self, session_data):
        """Crear nueva sesión de usuario"""
        try:
            values = {
                'user_id': self.env.uid,
                'session_id': session_data.get('session_id'),
                'ip_address': session_data.get('ip_address'),
                'user_agent': session_data.get('user_agent'),
                'browser_info': json.dumps(session_data.get('browser_info', {})),
            }
            session = self.create(values)
            _logger.info(f"Nueva sesión creada: {session.session_id} para usuario {session.user_id.name}")
            return session.id
        except Exception as e:
            _logger.error(f"Error creando sesión: {str(e)}")
            return False
    
    @api.model
    def end_session(self, session_id, session_data):
        """Terminar sesión existente"""
        try:
            session = self.search([('session_id', '=', session_id)], limit=1)
            if session:
                session.write({
                    'logout_time': fields.Datetime.now(),
                    'is_active': False,
                    'clicks_total': session_data.get('clicks_total', session.clicks_total),
                    'keystrokes_total': session_data.get('keystrokes_total', session.keystrokes_total),
                    'active_time_minutes': session_data.get('active_time_minutes', session.active_time_minutes),
                    'idle_time_minutes': session_data.get('idle_time_minutes', session.idle_time_minutes),
                })
                _logger.info(f"Sesión terminada: {session_id}")
                return True
            return False
        except Exception as e:
            _logger.error(f"Error terminando sesión: {str(e)}")
            return False
    
    @api.model
    def update_activity(self, session_id, activity_data):
        """Actualizar actividad de sesión"""
        try:
            session = self.search([('session_id', '=', session_id), ('is_active', '=', True)], limit=1)
            if session:
                update_vals = {
                    'last_activity': fields.Datetime.now(),
                }
                
                # Actualizar contadores incrementalmente
                if 'clicks_increment' in activity_data:
                    update_vals['clicks_total'] = session.clicks_total + activity_data['clicks_increment']
                if 'keystrokes_increment' in activity_data:
                    update_vals['keystrokes_total'] = session.keystrokes_total + activity_data['keystrokes_increment']
                if 'pages_increment' in activity_data:
                    update_vals['pages_visited'] = session.pages_visited + activity_data['pages_increment']
                
                session.write(update_vals)
                return True
            return False
        except Exception as e:
            _logger.error(f"Error actualizando actividad: {str(e)}")
            return False
EOF

echo "📝 Creando models/form_session.py..."
cat > "$MODULE_PATH/models/form_session.py" << 'EOF'
# -*- coding: utf-8 -*-
from odoo import models, fields, api
import json
import logging

_logger = logging.getLogger(__name__)

class FormSession(models.Model):
    _name = 'hexagonos.form.session'
    _description = 'Form Interaction Tracking'
    _order = 'start_time desc'
    _rec_name = 'form_display'

    # Relaciones
    user_id = fields.Many2one('res.users', string='Usuario', required=True, ondelete='cascade')
    user_session_id = fields.Many2one('hexagonos.user.session', string='Sesión Usuario', ondelete='cascade')
    
    # Información del formulario
    model_name = fields.Char(string='Modelo', required=True, index=True)
    model_display_name = fields.Char(string='Nombre del Modelo')
    record_id = fields.Integer(string='ID Registro')
    form_type = fields.Selection([
        ('create', 'Crear'),
        ('edit', 'Editar'), 
        ('view', 'Ver'),
        ('list', 'Lista'),
        ('kanban', 'Kanban')
    ], string='Tipo de Vista', required=True)
    
    # Métricas de tiempo
    start_time = fields.Datetime(string='Inicio', default=fields.Datetime.now, required=True)
    end_time = fields.Datetime(string='Fin')
    duration_seconds = fields.Float(string='Duración (segundos)', compute='_compute_duration', store=True)
    
    # Datos de interacción
    fields_modified = fields.Text(string='Campos Modificados (JSON)')
    clicks_count = fields.Integer(string='Clicks Realizados', default=0)
    keystrokes_count = fields.Integer(string='Teclas Presionadas', default=0)
    
    # Estado del formulario
    was_saved = fields.Boolean(string='Guardado Exitoso', default=False)
    was_cancelled = fields.Boolean(string='Cancelado', default=False)
    had_validation_errors = fields.Boolean(string='Errores de Validación', default=False)
    error_messages = fields.Text(string='Mensajes de Error')
    
    # Campo calculado para display
    form_display = fields.Char(string='Formulario', compute='_compute_form_display')
    
    @api.depends('model_name', 'form_type', 'start_time')
    def _compute_form_display(self):
        for record in self:
            model_name = record.model_display_name or record.model_name or 'Unknown'
            form_type = dict(record._fields['form_type'].selection).get(record.form_type, 'Unknown')
            time_str = record.start_time.strftime('%H:%M:%S') if record.start_time else ''
            record.form_display = f"{model_name} ({form_type}) - {time_str}"
    
    @api.depends('start_time', 'end_time')
    def _compute_duration(self):
        for record in self:
            if record.start_time and record.end_time:
                delta = record.end_time - record.start_time
                record.duration_seconds = delta.total_seconds()
            else:
                record.duration_seconds = 0
    
    @api.model
    def start_form_session(self, form_data):
        """Iniciar tracking de formulario"""
        try:
            # Buscar sesión activa del usuario
            user_session = self.env['hexagonos.user.session'].search([
                ('user_id', '=', self.env.uid),
                ('is_active', '=', True)
            ], limit=1, order='login_time desc')
            
            # Obtener nombre legible del modelo
            model_display_name = ''
            try:
                if form_data.get('model_name'):
                    model_obj = self.env[form_data['model_name']]
                    model_display_name = model_obj._description or form_data['model_name']
            except:
                model_display_name = form_data.get('model_name', '')
            
            values = {
                'user_id': self.env.uid,
                'user_session_id': user_session.id if user_session else False,
                'model_name': form_data.get('model_name'),
                'model_display_name': model_display_name,
                'record_id': form_data.get('record_id', 0),
                'form_type': form_data.get('form_type', 'view'),
                'start_time': fields.Datetime.now(),
            }
            
            form_session = self.create(values)
            _logger.info(f"Iniciado tracking de formulario: {form_session.model_name} por {form_session.user_id.name}")
            return form_session.id
            
        except Exception as e:
            _logger.error(f"Error iniciando form session: {str(e)}")
            return False
    
    @api.model
    def end_form_session(self, form_session_id, end_data):
        """Terminar tracking de formulario"""
        try:
            form_session = self.browse(form_session_id)
            if form_session.exists():
                values = {
                    'end_time': fields.Datetime.now(),
                    'clicks_count': end_data.get('clicks_count', form_session.clicks_count),
                    'keystrokes_count': end_data.get('keystrokes_count', form_session.keystrokes_count),
                    'was_saved': end_data.get('was_saved', False),
                    'was_cancelled': end_data.get('was_cancelled', False),
                    'had_validation_errors': end_data.get('had_validation_errors', False),
                    'error_messages': end_data.get('error_messages', ''),
                }
                
                # Guardar campos modificados
                if end_data.get('fields_modified'):
                    values['fields_modified'] = json.dumps(end_data['fields_modified'])
                
                form_session.write(values)
                _logger.info(f"Terminado tracking de formulario: {form_session.model_name}")
                return True
            return False
            
        except Exception as e:
            _logger.error(f"Error terminando form session: {str(e)}")
            return False
    
    @api.model
    def get_model_statistics(self, date_from=None, date_to=None, user_ids=None):
        """Obtener estadísticas por modelo"""
        domain = []
        
        if date_from:
            domain.append(('start_time', '>=', date_from))
        if date_to:
            domain.append(('start_time', '<=', date_to))
        if user_ids:
            domain.append(('user_id', 'in', user_ids))
        
        # Agrupar por modelo y tipo
        result = self.read_group(
            domain=domain,
            fields=['model_name', 'form_type', 'duration_seconds', 'was_saved'],
            groupby=['model_name', 'form_type'],
            lazy=False
        )
        
        statistics = {}
        for group in result:
            model = group['model_name']
            form_type = group['form_type']
            
            if model not in statistics:
                statistics[model] = {}
            
            statistics[model][form_type] = {
                'count': group['__count'],
                'avg_duration': group['duration_seconds'] / group['__count'] if group['__count'] else 0,
                'success_rate': group['was_saved'] / group['__count'] if group['__count'] else 0,
            }
        
        return statistics
EOF

echo "📝 Creando models/productivity_metrics.py..."
cat > "$MODULE_PATH/models/productivity_metrics.py" << 'EOF'
# -*- coding: utf-8 -*-
from odoo import models, fields, api
from datetime import datetime, timedelta
import logging

_logger = logging.getLogger(__name__)

class ProductivityMetrics(models.Model):
    _name = 'hexagonos.productivity.metrics'
    _description = 'Daily User Productivity Metrics'
    _order = 'date desc, user_id'
    _rec_name = 'metric_display'

    # Identificadores
    user_id = fields.Many2one('res.users', string='Usuario', required=True, ondelete='cascade')
    date = fields.Date(string='Fecha', default=fields.Date.today, required=True)
    
    # Métricas de tiempo
    total_session_time_hours = fields.Float(string='Tiempo Total Sesión (h)')
    active_time_hours = fields.Float(string='Tiempo Activo (h)')
    idle_time_hours = fields.Float(string='Tiempo Inactivo (h)')
    
    # Métricas de productividad
    records_created = fields.Integer(string='Registros Creados', default=0)
    records_edited = fields.Integer(string='Registros Editados', default=0)
    records_viewed = fields.Integer(string='Registros Vistos', default=0)
    forms_completed = fields.Integer(string='Formularios Completados', default=0)
    forms_cancelled = fields.Integer(string='Formularios Cancelados', default=0)
    
    # Métricas de interacción
    total_clicks = fields.Integer(string='Total Clicks', default=0)
    total_keystrokes = fields.Integer(string='Total Teclas', default=0)
    pages_visited = fields.Integer(string='Páginas Visitadas', default=0)
    unique_models_used = fields.Integer(string='Modelos Únicos Usados', default=0)
    
    # Métricas de eficiencia
    avg_form_completion_time = fields.Float(string='Tiempo Promedio Formulario (min)')
    success_rate_percentage = fields.Float(string='Tasa de Éxito (%)')
    efficiency_score = fields.Float(string='Score Eficiencia', compute='_compute_efficiency_score', store=True)
    
    # Métricas comparativas
    vs_yesterday_efficiency = fields.Float(string='vs Ayer (%)')
    vs_week_avg_efficiency = fields.Float(string='vs Promedio Semana (%)')
    
    # Campo display
    metric_display = fields.Char(string='Métrica', compute='_compute_metric_display')
    
    @api.depends('user_id', 'date')
    def _compute_metric_display(self):
        for record in self:
            if record.user_id and record.date:
                record.metric_display = f"{record.user_id.name} - {record.date.strftime('%d/%m/%Y')}"
            else:
                record.metric_display = "Métrica sin identificar"
    
    @api.depends('active_time_hours', 'records_created', 'records_edited', 'success_rate_percentage')
    def _compute_efficiency_score(self):
        for record in self:
            if record.active_time_hours > 0:
                # Fórmula de eficiencia: (acciones * tasa_éxito) / tiempo_activo
                actions = record.records_created + record.records_edited
                success_factor = record.success_rate_percentage / 100 if record.success_rate_percentage else 1
                record.efficiency_score = (actions * success_factor) / record.active_time_hours
            else:
                record.efficiency_score = 0
    
    @api.model
    def calculate_daily_metrics(self, user_id=None, date=None):
        """Calcular métricas diarias para un usuario"""
        if not date:
            date = fields.Date.today()
        if not user_id:
            user_id = self.env.uid
        
        try:
            # Buscar o crear registro de métricas
            metric = self.search([('user_id', '=', user_id), ('date', '=', date)])
            if not metric:
                metric = self.create({'user_id': user_id, 'date': date})
            
            # Calcular desde sesiones
            sessions = self.env['hexagonos.user.session'].search([
                ('user_id', '=', user_id),
                ('login_time', '>=', date),
                ('login_time', '<', date + timedelta(days=1))
            ])
            
            # Calcular desde formularios
            forms = self.env['hexagonos.form.session'].search([
                ('user_id', '=', user_id),
                ('start_time', '>=', date),
                ('start_time', '<', date + timedelta(days=1))
            ])
            
            # Agregar datos de sesiones
            total_session_time = sum(sessions.mapped('duration_hours'))
            active_time = sum(sessions.mapped('active_time_minutes')) / 60  # convertir a horas
            idle_time = sum(sessions.mapped('idle_time_minutes')) / 60
            total_clicks = sum(sessions.mapped('clicks_total'))
            total_keystrokes = sum(sessions.mapped('keystrokes_total'))
            pages_visited = sum(sessions.mapped('pages_visited'))
            
            # Agregar datos de formularios
            records_created = len(forms.filtered(lambda f: f.form_type == 'create' and f.was_saved))
            records_edited = len(forms.filtered(lambda f: f.form_type == 'edit' and f.was_saved))
            records_viewed = len(forms.filtered(lambda f: f.form_type == 'view'))
            forms_completed = len(forms.filtered(lambda f: f.was_saved))
            forms_cancelled = len(forms.filtered(lambda f: f.was_cancelled))
            unique_models = len(set(forms.mapped('model_name')))
            
            # Calcular promedios
            completed_forms = forms.filtered(lambda f: f.end_time)
            avg_completion_time = 0
            if completed_forms:
                avg_completion_time = sum(completed_forms.mapped('duration_seconds')) / len(completed_forms) / 60  # minutos
            
            success_rate = 0
            if forms:
                success_rate = (forms_completed / len(forms)) * 100
            
            # Actualizar registro
            values = {
                'total_session_time_hours': total_session_time,
                'active_time_hours': active_time,
                'idle_time_hours': idle_time,
                'records_created': records_created,
                'records_edited': records_edited,
                'records_viewed': records_viewed,
                'forms_completed': forms_completed,
                'forms_cancelled': forms_cancelled,
                'total_clicks': total_clicks,
                'total_keystrokes': total_keystrokes,
                'pages_visited': pages_visited,
                'unique_models_used': unique_models,
                'avg_form_completion_time': avg_completion_time,
                'success_rate_percentage': success_rate,
            }
            
            metric.write(values)
            
            # Calcular comparativas
            self._calculate_comparative_metrics(metric)
            
            _logger.info(f"Métricas calculadas para usuario {user_id} fecha {date}")
            return metric.id
            
        except Exception as e:
            _logger.error(f"Error calculando métricas: {str(e)}")
            return False
    
    def _calculate_comparative_metrics(self, current_metric):
        """Calcular métricas comparativas"""
        try:
            user_id = current_metric.user_id.id
            current_date = current_metric.date
            
            # Comparar con ayer
            yesterday = current_date - timedelta(days=1)
            yesterday_metric = self.search([('user_id', '=', user_id), ('date', '=', yesterday)])
            
            if yesterday_metric:
                if yesterday_metric.efficiency_score > 0:
                    vs_yesterday = ((current_metric.efficiency_score - yesterday_metric.efficiency_score) / yesterday_metric.efficiency_score) * 100
                    current_metric.vs_yesterday_efficiency = vs_yesterday
            
            # Comparar con promedio de la semana
            week_start = current_date - timedelta(days=current_date.weekday())
            week_metrics = self.search([
                ('user_id', '=', user_id),
                ('date', '>=', week_start),
                ('date', '<', current_date)
            ])
            
            if week_metrics:
                week_avg = sum(week_metrics.mapped('efficiency_score')) / len(week_metrics)
                if week_avg > 0:
                    vs_week = ((current_metric.efficiency_score - week_avg) / week_avg) * 100
                    current_metric.vs_week_avg_efficiency = vs_week
                    
        except Exception as e:
            _logger.error(f"Error calculando comparativas: {str(e)}")
    
    @api.model
    def get_user_ranking(self, date=None, limit=10):
        """Obtener ranking de usuarios por eficiencia"""
        if not date:
            date = fields.Date.today()
        
        metrics = self.search([
            ('date', '=', date),
            ('efficiency_score', '>', 0)
        ], order='efficiency_score desc', limit=limit)
        
        ranking = []
        for i, metric in enumerate(metrics, 1):
            ranking.append({
                'rank': i,
                'user_name': metric.user_id.name,
                'efficiency_score': metric.efficiency_score,
                'actions': metric.records_created + metric.records_edited,
                'active_time': metric.active_time_hours,
                'success_rate': metric.success_rate_percentage,
            })
        
        return ranking
EOF

echo "📝 Creando models/analytics_dashboard.py..."
cat > "$MODULE_PATH/models/analytics_dashboard.py" << 'EOF'
# -*- coding: utf-8 -*-
from odoo import models, fields, api
from datetime import datetime, timedelta
import json
import logging

_logger = logging.getLogger(__name__)

class AnalyticsDashboard(models.TransientModel):
    _name = 'hexagonos.analytics.dashboard'
    _description = 'Analytics Dashboard Controller'

    # Filtros de dashboard
    date_from = fields.Date(string='Fecha Desde', default=lambda self: fields.Date.today() - timedelta(days=7))
    date_to = fields.Date(string='Fecha Hasta', default=fields.Date.today)
    user_ids = fields.Many2many('res.users', string='Usuarios')
    department_ids = fields.Many2many('hr.department', string='Departamentos')
    
    @api.model
    def get_dashboard_data(self, filters=None):
        """Obtener todos los datos para el dashboard"""
        try:
            if not filters:
                filters = {}
            
            date_from = filters.get('date_from', fields.Date.today() - timedelta(days=7))
            date_to = filters.get('date_to', fields.Date.today())
            user_ids = filters.get('user_ids', [])
            
            # Convertir strings a objetos date si es necesario
            if isinstance(date_from, str):
                date_from = datetime.strptime(date_from, '%Y-%m-%d').date()
            if isinstance(date_to, str):
                date_to = datetime.strptime(date_to, '%Y-%m-%d').date()
            
            data = {
                'summary_metrics': self._get_summary_metrics(date_from, date_to, user_ids),
                'user_ranking': self._get_user_ranking(date_to, user_ids),
                'hourly_activity': self._get_hourly_activity(date_from, date_to, user_ids),
                'model_usage': self._get_model_usage(date_from, date_to, user_ids),
                'daily_trends': self._get_daily_trends(date_from, date_to, user_ids),
                'form_completion_times': self._get_form_completion_times(date_from, date_to, user_ids),
                'alerts_and_anomalies': self._get_alerts_and_anomalies(date_from, date_to, user_ids),
            }
            
            return data
            
        except Exception as e:
            _logger.error(f"Error obteniendo datos dashboard: {str(e)}")
            return {'error': str(e)}
    
    def _get_summary_metrics(self, date_from, date_to, user_ids):
        """Métricas generales de resumen"""
        domain = [('date', '>=', date_from), ('date', '<=', date_to)]
        if user_ids:
            domain.append(('user_id', 'in', user_ids))
        
        metrics = self.env['hexagonos.productivity.metrics'].search(domain)
        
        if not metrics:
            return {
                'total_users': 0,
                'avg_session_time': 0,
                'total_actions': 0,
                'avg_efficiency': 0,
                'total_forms_completed': 0,
                'success_rate': 0,
            }
        
        return {
            'total_users': len(metrics.mapped('user_id')),
            'avg_session_time': sum(metrics.mapped('total_session_time_hours')) / len(metrics),
            'total_actions': sum(metrics.mapped('records_created')) + sum(metrics.mapped('records_edited')),
            'avg_efficiency': sum(metrics.mapped('efficiency_score')) / len(metrics),
            'total_forms_completed': sum(metrics.mapped('forms_completed')),
            'success_rate': sum(metrics.mapped('success_rate_percentage')) / len(metrics),
        }
    
    def _get_user_ranking(self, date_to, user_ids):
        """Top usuarios por eficiencia"""
        domain = [('date', '=', date_to)]
        if user_ids:
            domain.append(('user_id', 'in', user_ids))
        
        metrics = self.env['hexagonos.productivity.metrics'].search(
            domain, 
            order='efficiency_score desc', 
            limit=10
        )
        
        ranking = []
        for i, metric in enumerate(metrics, 1):
            ranking.append({
                'rank': i,
                'user_name': metric.user_id.name,
                'efficiency_score': round(metric.efficiency_score, 2),
                'total_actions': metric.records_created + metric.records_edited,
                'active_time': round(metric.active_time_hours, 2),
                'success_rate': round(metric.success_rate_percentage, 1),
            })
        
        return ranking
    
    def _get_hourly_activity(self, date_from, date_to, user_ids):
        """Actividad por hora del día"""
        session_domain = [
            ('login_time', '>=', datetime.combine(date_from, datetime.min.time())),
            ('login_time', '<=', datetime.combine(date_to, datetime.max.time()))
        ]
        if user_ids:
            session_domain.append(('user_id', 'in', user_ids))
        
        sessions = self.env['hexagonos.user.session'].search(session_domain)
        
        # Inicializar array de 24 horas
        hourly_data = [{'hour': f"{i:02d}:00", 'active_users': 0, 'total_actions': 0} for i in range(24)]
        
        for session in sessions:
            if session.login_time:
                hour = session.login_time.hour
                hourly_data[hour]['active_users'] += 1
                hourly_data[hour]['total_actions'] += session.records_created + session.records_edited
        
        return hourly_data
    
    def _get_model_usage(self, date_from, date_to, user_ids):
        """Uso por modelo/formulario"""
        form_domain = [
            ('start_time', '>=', datetime.combine(date_from, datetime.min.time())),
            ('start_time', '<=', datetime.combine(date_to, datetime.max.time()))
        ]
        if user_ids:
            form_domain.append(('user_id', 'in', user_ids))
        
        forms_data = self.env['hexagonos.form.session'].read_group(
            domain=form_domain,
            fields=['model_display_name', 'duration_seconds'],
            groupby='model_display_name'
        )
        
        model_usage = []
        for data in forms_data:
            model_usage.append({
                'model': data['model_display_name'] or 'Sin nombre',
                'usage_count': data['model_display_name_count'],
                'avg_time_seconds': data['duration_seconds'] / data['model_display_name_count'] if data['model_display_name_count'] else 0,
            })
        
        # Ordenar por uso descendente
        model_usage.sort(key=lambda x: x['usage_count'], reverse=True)
        return model_usage[:10]  # Top 10
    
    def _get_daily_trends(self, date_from, date_to, user_ids):
        """Tendencias diarias"""
        domain = [('date', '>=', date_from), ('date', '<=', date_to)]
        if user_ids:
            domain.append(('user_id', 'in', user_ids))
        
        daily_data = self.env['hexagonos.productivity.metrics'].read_group(
            domain=domain,
            fields=['date', 'efficiency_score', 'total_session_time_hours', 'records_created', 'records_edited'],
            groupby='date:day'
        )
        
        trends = []
        for data in daily_data:
            date_str = data['date:day']
            count = data['date_count']
            trends.append({
                'date': date_str,
                'avg_efficiency': data['efficiency_score'] / count if count else 0,
                'avg_session_time': data['total_session_time_hours'] / count if count else 0,
                'total_actions': data['records_created'] + data['records_edited'],
                'active_users': count,
            })
        
        trends.sort(key=lambda x: x['date'])
        return trends
    
    def _get_form_completion_times(self, date_from, date_to, user_ids):
        """Tiempos de completado de formularios"""
        form_domain = [
            ('start_time', '>=', datetime.combine(date_from, datetime.min.time())),
            ('start_time', '<=', datetime.combine(date_to, datetime.max.time())),
            ('was_saved', '=', True),
            ('duration_seconds', '>', 0)
        ]
        if user_ids:
            form_domain.append(('user_id', 'in', user_ids))
        
        completion_data = self.env['hexagonos.form.session'].read_group(
            domain=form_domain,
            fields=['model_display_name', 'duration_seconds'],
            groupby='model_display_name'
        )
        
        completion_times = []
        for data in completion_data:
            avg_time_minutes = (data['duration_seconds'] / data['model_display_name_count']) / 60 if data['model_display_name_count'] else 0
            completion_times.append({
                'model': data['model_display_name'] or 'Sin nombre',
                'count': data['model_display_name_count'],
                'avg_time_minutes': round(avg_time_minutes, 2),
            })
        
        completion_times.sort(key=lambda x: x['avg_time_minutes'], reverse=True)
        return completion_times[:10]
    
    def _get_alerts_and_anomalies(self, date_from, date_to, user_ids):
        """Alertas y anomalías detectadas"""
        alerts = []
        
        # Buscar usuarios con baja productividad
        domain = [('date', '>=', date_from), ('date', '<=', date_to)]
        if user_ids:
            domain.append(('user_id', 'in', user_ids))
        
        metrics = self.env['hexagonos.productivity.metrics'].search(domain)
        
        if metrics:
            avg_efficiency = sum(metrics.mapped('efficiency_score')) / len(metrics)
            low_performers = metrics.filtered(lambda m: m.efficiency_score < avg_efficiency * 0.7)
            
            if low_performers:
                alerts.append({
                    'type': 'warning',
                    'title': 'Baja Productividad',
                    'message': f'{len(low_performers)} usuarios con eficiencia 30% bajo promedio',
                    'count': len(low_performers)
                })
        
        # Buscar formularios con tiempo excesivo
        form_domain = [
            ('start_time', '>=', datetime.combine(date_from, datetime.min.time())),
            ('start_time', '<=', datetime.combine(date_to, datetime.max.time())),
            ('duration_seconds', '>', 600)  # Más de 10 minutos
        ]
        if user_ids:
            form_domain.append(('user_id', 'in', user_ids))
        
        slow_forms = self.env['hexagonos.form.session'].search_count(form_domain)
        if slow_forms > 0:
            alerts.append({
                'type': 'danger',
                'title': 'Formularios Lentos',
                'message': f'{slow_forms} formularios tardaron más de 10 minutos',
                'count': slow_forms
            })
        
        # Buscar sesiones anómalas (muy largas o muy cortas)
        session_domain = [
            ('login_time', '>=', datetime.combine(date_from, datetime.min.time())),
            ('login_time', '<=', datetime.combine(date_to, datetime.max.time())),
        ]
        if user_ids:
            session_domain.append(('user_id', 'in', user_ids))
        
        long_sessions = self.env['hexagonos.user.session'].search_count(
            session_domain + [('duration_hours', '>', 12)]
        )
        if long_sessions > 0:
            alerts.append({
                'type': 'info',
                'title': 'Sesiones Largas',
                'message': f'{long_sessions} sesiones de más de 12 horas detectadas',
                'count': long_sessions
            })
        
        return alerts
EOF

# 4. CONTROLADOR WEB
echo "📝 Creando controllers/analytics_controller.py..."
cat > "$MODULE_PATH/controllers/analytics_controller.py" << 'EOF'
# -*- coding: utf-8 -*-
from odoo import http
from odoo.http import request
import json
import logging

_logger = logging.getLogger(__name__)

class AnalyticsController(http.Controller):
    
    @http.route('/hexagonos_analytics/start_session', type='json', auth='user', methods=['POST'])
    def start_session(self, session_data):
        """Iniciar nueva sesión de usuario"""
        try:
            session_model = request.env['hexagonos.user.session']
            session_id = session_model.create_session(session_data)
            return {'success': True, 'session_id': session_id}
        except Exception as e:
            _logger.error(f"Error en start_session: {str(e)}")
            return {'success': False, 'error': str(e)}
    
    @http.route('/hexagonos_analytics/end_session', type='http', auth='user', methods=['POST'], csrf=False)
    def end_session(self, **post):
        """Terminar sesión existente"""
        try:
            session_id = post.get('session_id')
            if session_id:
                session_data = {
                    'clicks_total': int(post.get('clicks', 0)),
                    'keystrokes_total': int(post.get('keystrokes', 0)),
                    'active_time_minutes': float(post.get('active_time', 0)),
                    'idle_time_minutes': float(post.get('idle_time', 0)),
                }
                
                session_model = request.env['hexagonos.user.session']
                success = session_model.end_session(session_id, session_data)
                return request.make_response('OK' if success else 'ERROR')
            return request.make_response('NO_SESSION_ID')
        except Exception as e:
            _logger.error(f"Error en end_session: {str(e)}")
            return request.make_response(f'ERROR: {str(e)}')
    
    @http.route('/hexagonos_analytics/track_activity', type='json', auth='user', methods=['POST'])
    def track_activity(self, session_id, activity_data):
        """Actualizar actividad de sesión"""
        try:
            session_model = request.env['hexagonos.user.session']
            success = session_model.update_activity(session_id, activity_data)
            return {'success': success}
        except Exception as e:
            _logger.error(f"Error en track_activity: {str(e)}")
            return {'success': False, 'error': str(e)}
    
    @http.route('/hexagonos_analytics/start_form', type='json', auth='user', methods=['POST'])
    def start_form_tracking(self, form_data):
        """Iniciar tracking de formulario"""
        try:
            form_model = request.env['hexagonos.form.session']
            form_session_id = form_model.start_form_session(form_data)
            return {'success': True, 'form_session_id': form_session_id}
        except Exception as e:
            _logger.error(f"Error en start_form_tracking: {str(e)}")
            return {'success': False, 'error': str(e)}
    
    @http.route('/hexagonos_analytics/end_form', type='json', auth='user', methods=['POST'])
    def end_form_tracking(self, form_session_id, end_data):
        """Terminar tracking de formulario"""
        try:
            form_model = request.env['hexagonos.form.session']
            success = form_model.end_form_session(form_session_id, end_data)
            return {'success': success}
        except Exception as e:
            _logger.error(f"Error en end_form_tracking: {str(e)}")
            return {'success': False, 'error': str(e)}
    
    @http.route('/hexagonos_analytics/dashboard_data', type='json', auth='user', methods=['POST'])
    def get_dashboard_data(self, filters=None):
        """Obtener datos para dashboard"""
        try:
            dashboard_model = request.env['hexagonos.analytics.dashboard']
            data = dashboard_model.get_dashboard_data(filters)
            return {'success': True, 'data': data}
        except Exception as e:
            _logger.error(f"Error en dashboard_data: {str(e)}")
            return {'success': False, 'error': str(e)}
    
    @http.route('/hexagonos_analytics/user_ranking', type='json', auth='user', methods=['POST'])
    def get_user_ranking(self, date=None, limit=10):
        """Obtener ranking de usuarios"""
        try:
            metrics_model = request.env['hexagonos.productivity.metrics']
            ranking = metrics_model.get_user_ranking(date, limit)
            return {'success': True, 'ranking': ranking}
        except Exception as e:
            _logger.error(f"Error en user_ranking: {str(e)}")
            return {'success': False, 'error': str(e)}
    
    @http.route('/hexagonos_analytics/calculate_metrics', type='json', auth='user', methods=['POST'])
    def calculate_daily_metrics(self, user_id=None, date=None):
        """Calcular métricas diarias"""
        try:
            metrics_model = request.env['hexagonos.productivity.metrics']
            metric_id = metrics_model.calculate_daily_metrics(user_id, date)
            return {'success': True, 'metric_id': metric_id}
        except Exception as e:
            _logger.error(f"Error en calculate_metrics: {str(e)}")
            return {'success': False, 'error': str(e)}
EOF

# 5. SEGURIDAD
echo "📝 Creando security/security.xml..."
cat > "$MODULE_PATH/security/security.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <data noupdate="1">
        
        <!-- Grupo de Analytics Manager -->
        <record id="group_analytics_manager" model="res.groups">
            <field name="name">Analytics Manager</field>
            <field name="category_id" ref="base.module_category_administration"/>
            <field name="comment">Puede ver todos los analytics y configurar el sistema</field>
        </record>
        
        <!-- Grupo de Analytics User -->
        <record id="group_analytics_user" model="res.groups">
            <field name="name">Analytics User</field>
            <field name="category_id" ref="base.module_category_administration"/>
            <field name="comment">Puede ver sus propios analytics</field>
        </record>
        
        <!-- Regla: Los usuarios solo pueden ver sus propias sesiones -->
        <record id="user_session_user_rule" model="ir.rule">
            <field name="name">User Session: Own Sessions Only</field>
            <field name="model_id" ref="model_hexagonos_user_session"/>
            <field name="domain_force">[('user_id', '=', user.id)]</field>
            <field name="groups" eval="[(4, ref('group_analytics_user'))]"/>
        </record>
        
        <!-- Regla: Los managers pueden ver todas las sesiones -->
        <record id="user_session_manager_rule" model="ir.rule">
            <field name="name">User Session: Manager Access</field>
            <field name="model_id" ref="model_hexagonos_user_session"/>
            <field name="domain_force">[(1, '=', 1)]</field>
            <field name="groups" eval="[(4, ref('group_analytics_manager'))]"/>
        </record>
        
        <!-- Regla: Los usuarios solo pueden ver sus propios formularios -->
        <record id="form_session_user_rule" model="ir.rule">
            <field name="name">Form Session: Own Forms Only</field>
            <field name="model_id" ref="model_hexagonos_form_session"/>
            <field name="domain_force">[('user_id', '=', user.id)]</field>
            <field name="groups" eval="[(4, ref('group_analytics_user'))]"/>
        </record>
        
        <!-- Regla: Los managers pueden ver todos los formularios -->
        <record id="form_session_manager_rule" model="ir.rule">
            <field name="name">Form Session: Manager Access</field>
            <field name="model_id" ref="model_hexagonos_form_session"/>
            <field name="domain_force">[(1, '=', 1)]</field>
            <field name="groups" eval="[(4, ref('group_analytics_manager'))]"/>
        </record>
        
        <!-- Regla: Los usuarios solo pueden ver sus propias métricas -->
        <record id="productivity_metrics_user_rule" model="ir.rule">
            <field name="name">Productivity Metrics: Own Metrics Only</field>
            <field name="model_id" ref="model_hexagonos_productivity_metrics"/>
            <field name="domain_force">[('user_id', '=', user.id)]</field>
            <field name="groups" eval="[(4, ref('group_analytics_user'))]"/>
        </record>
        
        <!-- Regla: Los managers pueden ver todas las métricas -->
        <record id="productivity_metrics_manager_rule" model="ir.rule">
            <field name="name">Productivity Metrics: Manager Access</field>
            <field name="model_id" ref="model_hexagonos_productivity_metrics"/>
            <field name="domain_force">[(1, '=', 1)]</field>
            <field name="groups" eval="[(4, ref('group_analytics_manager'))]"/>
        </record>
        
    </data>
</odoo>
EOF

echo "📝 Creando security/ir.model.access.csv..."
cat > "$MODULE_PATH/security/ir.model.access.csv" << 'EOF'
id,name,model_id:id,group_id:id,perm_read,perm_write,perm_create,perm_unlink
access_user_session_user,hexagonos.user.session user,model_hexagonos_user_session,group_analytics_user,1,1,1,0
access_user_session_manager,hexagonos.user.session manager,model_hexagonos_user_session,group_analytics_manager,1,1,1,1
access_form_session_user,hexagonos.form.session user,model_hexagonos_form_session,group_analytics_user,1,1,1,0
access_form_session_manager,hexagonos.form.session manager,model_hexagonos_form_session,group_analytics_manager,1,1,1,1
access_productivity_metrics_user,hexagonos.productivity.metrics user,model_hexagonos_productivity_metrics,group_analytics_user,1,0,0,0
access_productivity_metrics_manager,hexagonos.productivity.metrics manager,model_hexagonos_productivity_metrics,group_analytics_manager,1,1,1,1
access_analytics_dashboard_user,hexagonos.analytics.dashboard user,model_hexagonos_analytics_dashboard,group_analytics_user,1,1,1,1
access_analytics_dashboard_manager,hexagonos.analytics.dashboard manager,model_hexagonos_analytics_dashboard,group_analytics_manager,1,1,1,1
EOF

# 6. JAVASCRIPT - MOTOR DE TRACKING
echo "📝 Creando static/src/js/user_tracker.js..."
cat > "$MODULE_PATH/static/src/js/user_tracker.js" << 'EOF'
/** @odoo-module **/

import { registry } from "@web/core/registry";
import { browser } from "@web/core/browser/browser";

const { DateTime } = luxon;

export class UserTracker {
    constructor() {
        this.sessionId = null;
        this.startTime = null;
        this.lastActivity = null;
        this.clicks = 0;
        this.keystrokes = 0;
        this.isActive = true;
        this.idleTimeout = null;
        this.idleThreshold = 5 * 60 * 1000; // 5 minutos
        this.activityBuffer = [];
        this.flushInterval = null;
        
        this.init();
    }
    
    init() {
        this.sessionId = this.generateSessionId();
        this.startTime = new Date();
        this.lastActivity = new Date();
        
        this.startSession();
        this.bindEvents();
        this.startActivityTracking();
        
        console.log('🔍 UserTracker initialized:', this.sessionId);
    }
    
    generateSessionId() {
        return 'HA_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    }
    
    async startSession() {
        try {
            const sessionData = {
                session_id: this.sessionId,
                ip_address: await this.getClientIP(),
                user_agent: navigator.userAgent,
                browser_info: this.getBrowserInfo(),
            };
            
            const result = await this.callOdoo('/hexagonos_analytics/start_session', sessionData);
            if (result.success) {
                console.log('✅ Session started successfully');
            }
        } catch (error) {
            console.error('❌ Error starting session:', error);
        }
    }
    
    bindEvents() {
        // Track clicks
        document.addEventListener('click', (e) => {
            this.clicks++;
            this.updateActivity();
            this.trackEvent('click', {
                target: e.target.tagName,
                className: e.target.className,
                x: e.clientX,
                y: e.clientY
            });
        });
        
        // Track keystrokes
        document.addEventListener('keydown', (e) => {
            this.keystrokes++;
            this.updateActivity();
            if (e.target.type !== 'password') {
                this.trackEvent('keystroke', {
                    key: e.key,
                    target: e.target.name || e.target.id
                });
            }
        });
        
        // Track mouse movement (for idle detection)
        document.addEventListener('mousemove', () => {
            this.updateActivity();
        });
        
        // Track window events
        window.addEventListener('beforeunload', () => {
            this.endSession();
        });
        
        // Track visibility changes
        document.addEventListener('visibilitychange', () => {
            if (document.hidden) {
                this.trackEvent('tab_hidden');
            } else {
                this.trackEvent('tab_visible');
                this.updateActivity();
            }
        });
    }
    
    updateActivity() {
        this.lastActivity = new Date();
        this.isActive = true;
        this.resetIdleTimer();
    }
    
    resetIdleTimer() {
        clearTimeout(this.idleTimeout);
        this.idleTimeout = setTimeout(() => {
            this.isActive = false;
            this.trackEvent('idle_start');
        }, this.idleThreshold);
    }
    
    startActivityTracking() {
        // Flush activity buffer every 30 seconds
        this.flushInterval = setInterval(() => {
            this.flushActivityBuffer();
        }, 30000);
        
        // Track session activity every minute
        setInterval(() => {
            this.trackSessionActivity();
        }, 60000);
    }
    
    trackEvent(eventType, data = {}) {
        this.activityBuffer.push({
            event_type: eventType,
            timestamp: new Date().toISOString(),
            data: data
        });
        
        // Flush buffer if it gets too large
        if (this.activityBuffer.length >= 50) {
            this.flushActivityBuffer();
        }
    }
    
    async flushActivityBuffer() {
        if (this.activityBuffer.length === 0) return;
        
        try {
            const activityData = {
                session_id: this.sessionId,
                events: [...this.activityBuffer],
                clicks_increment: this.clicks,
                keystrokes_increment: this.keystrokes,
            };
            
            await this.callOdoo('/hexagonos_analytics/track_activity', this.sessionId, activityData);
            this.activityBuffer = [];
            
        } catch (error) {
            console.error('❌ Error flushing activity:', error);
        }
    }
    
    async trackSessionActivity() {
        try {
            const now = new Date();
            const sessionTime = (now - this.startTime) / 1000 / 60; // minutos
            const idleTime = this.isActive ? 0 : (now - this.lastActivity) / 1000 / 60;
            const activeTime = sessionTime - idleTime;
            
            const activityData = {
                clicks_increment: this.clicks,
                keystrokes_increment: this.keystrokes,
                active_time_minutes: activeTime,
                idle_time_minutes: idleTime,
            };
            
            await this.callOdoo('/hexagonos_analytics/track_activity', this.sessionId, activityData);
            
        } catch (error) {
            console.error('❌ Error tracking session activity:', error);
        }
    }
    
    async endSession() {
        try {
            const endData = {
                session_id: this.sessionId,
                clicks: this.clicks,
                keystrokes: this.keystrokes,
                active_time: this.isActive ? (new Date() - this.startTime) / 1000 / 60 : 0,
                idle_time: this.isActive ? 0 : (new Date() - this.lastActivity) / 1000 / 60,
            };
            
            // Use sendBeacon for reliable delivery
            if (navigator.sendBeacon) {
                const formData = new FormData();
                Object.keys(endData).forEach(key => {
                    formData.append(key, endData[key]);
                });
                navigator.sendBeacon('/hexagonos_analytics/end_session', formData);
            }
            
            clearInterval(this.flushInterval);
            clearTimeout(this.idleTimeout);
            
        } catch (error) {
            console.error('❌ Error ending session:', error);
        }
    }
    
    async getClientIP() {
        try {
            const response = await fetch('https://api.ipify.org?format=json');
            const data = await response.json();
            return data.ip;
        } catch {
            return 'unknown';
        }
    }
    
    getBrowserInfo() {
        return {
            userAgent: navigator.userAgent,
            platform: navigator.platform,
            language: navigator.language,
            cookieEnabled: navigator.cookieEnabled,
            onLine: navigator.onLine,
            screenWidth: screen.width,
            screenHeight: screen.height,
            timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
        };
    }
    
    async callOdoo(endpoint, ...args) {
        const response = await fetch(endpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
            },
            body: JSON.stringify({
                jsonrpc: '2.0',
                method: 'call',
                params: args.length === 1 ? args[0] : args,
                id: Math.random(),
            }),
        });
        
        const result = await response.json();
        if (result.error) {
            throw new Error(result.error.message);
        }
        return result.result;
    }
    
    // Public API
    getStats() {
        return {
            sessionId: this.sessionId,
            sessionTime: (new Date() - this.startTime) / 1000 / 60, // minutes
            clicks: this.clicks,
            keystrokes: this.keystrokes,
            isActive: this.isActive,
            lastActivity: this.lastActivity,
        };
    }
}

// Initialize when DOM is ready
registry.category("services").add("userTracker", {
    dependencies: [],
    start() {
        // Wait for Odoo to be fully loaded
        setTimeout(() => {
            window.hexagonosTracker = new UserTracker();
        }, 2000);
    },
});
EOF

# 7. JAVASCRIPT - FORM TRACKER
echo "📝 Creando static/src/js/form_tracker.js..."
cat > "$MODULE_PATH/static/src/js/form_tracker.js" << 'EOF'
/** @odoo-module **/

import { registry } from "@web/core/registry";

export class FormTracker {
    constructor() {
        this.activeFormSessions = new Map();
        this.init();
    }
    
    init() {
        this.bindFormEvents();
        console.log('📝 FormTracker initialized');
    }
    
    bindFormEvents() {
        // Monitor for form view creation
        this.observeFormViews();
        
        // Track form saves
        document.addEventListener('click', (e) => {
            if (e.target.matches('.o_form_button_save, .btn-primary')) {
                this.handleFormSave(e.target);
            } else if (e.target.matches('.o_form_button_cancel, .btn-secondary')) {
                this.handleFormCancel(e.target);
            }
        });
        
        // Track field changes
        document.addEventListener('change', (e) => {
            if (e.target.matches('.o_form_view input, .o_form_view select, .o_form_view textarea')) {
                this.trackFieldChange(e.target);
            }
        });
    }
    
    observeFormViews() {
        const observer = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
                mutation.addedNodes.forEach((node) => {
                    if (node.nodeType === 1) { // Element node
                        // Check for form views
                        if (node.matches('.o_form_view') || node.querySelector('.o_form_view')) {
                            this.handleFormOpen(node);
                        }
                    }
                });
                
                mutation.removedNodes.forEach((node) => {
                    if (node.nodeType === 1 && (node.matches('.o_form_view') || node.querySelector('.o_form_view'))) {
                        this.handleFormClose(node);
                    }
                });
            });
        });
        
        observer.observe(document.body, { childList: true, subtree: true });
    }
    
    async handleFormOpen(formElement) {
        try {
            const formView = formElement.matches('.o_form_view') ? formElement : formElement.querySelector('.o_form_view');
            if (!formView) return;
            
            const formData = this.extractFormData(formView);
            const formId = this.generateFormId(formData);
            
            if (this.activeFormSessions.has(formId)) return; // Already tracking
            
            const response = await this.callOdoo('/hexagonos_analytics/start_form', formData);
            if (response.success) {
                this.activeFormSessions.set(formId, {
                    sessionId: response.form_session_id,
                    startTime: new Date(),
                    clicks: 0,
                    keystrokes: 0,
                    fieldsModified: {},
                    formElement: formView,
                });
                console.log('📝 Form tracking started:', formData.model_name);
            }
        } catch (error) {
            console.error('❌ Error starting form tracking:', error);
        }
    }
    
    handleFormClose(formElement) {
        const formView = formElement.matches('.o_form_view') ? formElement : formElement.querySelector('.o_form_view');
        if (!formView) return;
        
        const formData = this.extractFormData(formView);
        const formId = this.generateFormId(formData);
        
        if (this.activeFormSessions.has(formId)) {
            this.endFormSession(formId, { was_cancelled: true });
        }
    }
    
    async handleFormSave(saveButton) {
        const formView = saveButton.closest('.o_form_view');
        if (!formView) return;
        
        const formData = this.extractFormData(formView);
        const formId = this.generateFormId(formData);
        
        if (this.activeFormSessions.has(formId)) {
            await this.endFormSession(formId, { was_saved: true });
        }
    }
    
    async handleFormCancel(cancelButton) {
        const formView = cancelButton.closest('.o_form_view');
        if (!formView) return;
        
        const formData = this.extractFormData(formView);
        const formId = this.generateFormId(formData);
        
        if (this.activeFormSessions.has(formId)) {
            await this.endFormSession(formId, { was_cancelled: true });
        }
    }
    
    trackFieldChange(field) {
        const formView = field.closest('.o_form_view');
        if (!formView) return;
        
        const formData = this.extractFormData(formView);
        const formId = this.generateFormId(formData);
        const session = this.activeFormSessions.get(formId);
        
        if (session) {
            const fieldName = field.name || field.id || 'unknown_field';
            session.fieldsModified[fieldName] = {
                oldValue: field.defaultValue || '',
                newValue: field.value || '',
                timestamp: new Date().toISOString(),
            };
        }
    }
    
    async endFormSession(formId, endData = {}) {
        const session = this.activeFormSessions.get(formId);
        if (!session) return;
        
        try {
            const finalData = {
                clicks_count: session.clicks,
                keystrokes_count: session.keystrokes,
                fields_modified: session.fieldsModified,
                ...endData,
            };
            
            const response = await this.callOdoo('/hexagonos_analytics/end_form', session.sessionId, finalData);
            if (response.success) {
                console.log('📝 Form tracking ended:', formId);
            }
            
            this.activeFormSessions.delete(formId);
        } catch (error) {
            console.error('❌ Error ending form session:', error);
        }
    }
    
    extractFormData(formView) {
        // Extract model name from data attributes or URL
        let modelName = '';
        let recordId = 0;
        let formType = 'view';
        
        // Try to get from data attributes
        const modelEl = formView.querySelector('[data-o-model]');
        if (modelEl) {
            modelName = modelEl.getAttribute('data-o-model');
        }
        
        const recordEl = formView.querySelector('[data-o-id]');
        if (recordEl) {
            recordId = parseInt(recordEl.getAttribute('data-o-id')) || 0;
        }
        
        // Determine form type
        if (recordId === 0 || formView.querySelector('.o_form_button_create')) {
            formType = 'create';
        } else if (formView.querySelector('.o_form_button_edit')) {
            formType = recordId > 0 ? 'edit' : 'create';
        }
        
        // Fallback: extract from URL or page title
        if (!modelName) {
            const url = window.location.href;
            const modelMatch = url.match(/model=([^&]+)/);
            if (modelMatch) {
                modelName = modelMatch[1];
            }
        }
        
        return {
            model_name: modelName || 'unknown',
            record_id: recordId,
            form_type: formType,
        };
    }
    
    generateFormId(formData) {
        return `${formData.model_name}_${formData.record_id}_${formData.form_type}`;
    }
    
    async callOdoo(endpoint, ...args) {
        const response = await fetch(endpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
            },
            body: JSON.stringify({
                jsonrpc: '2.0',
                method: 'call',
                params: args.length === 1 ? args[0] : args,
                id: Math.random(),
            }),
        });
        
        const result = await response.json();
        if (result.error) {
            throw new Error(result.error.message);
        }
        return result.result;
    }
}

// Initialize form tracker
registry.category("services").add("formTracker", {
    dependencies: [],
    start() {
        setTimeout(() => {
            window.hexagonosFormTracker = new FormTracker();
        }, 3000);
    },
});
EOF