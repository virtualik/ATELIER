package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * Интерактивный рой частиц.
 * Исправлены ошибки типизации (Void) и добавлена адаптивность.
 */
class Main extends Sprite {
    
    private var particles:Array<Particle>;
    private var numParticles:Int = 120;
    private var statusLabel:TextField;

    public function new() {
        super();
        
        // Дождемся добавления на сцену для правильных размеров stage
        if (stage != null) init();
        else addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(?e:Event):Void {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        
        particles = [];
        
        // Создаем частицы
        for (i in 0...numParticles) {
            var p = new Particle();
            addChild(p);
            particles.push(p);
        }

        // Добавляем текстовое поле для красоты
        statusLabel = new TextField();
        statusLabel.defaultTextFormat = new TextFormat("_sans", 14, 0x666666);
        statusLabel.text = "Particle Demo. Click to explode.";
        statusLabel.width = 400;
        statusLabel.x = 10;
        statusLabel.y = 10;
        statusLabel.selectable = false;
        addChild(statusLabel);
        
        // Слушатели событий
        addEventListener(Event.ENTER_FRAME, onUpdate);
        stage.addEventListener(MouseEvent.CLICK, onExplode);
    }

    private function onUpdate(e:Event):Void {
        // Используем координаты мыши или центр экрана, если мышь вне окна
        var tx:Float = (mouseX > 0) ? mouseX : stage.stageWidth / 2;
        var ty:Float = (mouseY > 0) ? mouseY : stage.stageHeight / 2;

        for (p in particles) {
            var dx = tx - p.x;
            var dy = ty - p.y;
            var dist = Math.sqrt(dx * dx + dy * dy);
			
           //p.alpha = 0.1 + (Math.abs(p.vx) + Math.abs(p.vy)) / 40;
			
            // Физика притяжения
            if (dist > 2) {
                p.vx += dx / 400;
                p.vy += dy / 400;
            }

            // Инерция и движение
            p.vx *= 0.94;
            p.vy *= 0.94;
            p.x += p.vx;
            p.y += p.vy;
            
            // Вращение по вектору скорости
            p.rotation = Math.atan2(p.vy, p.vx) * 180 / Math.PI;
           
            // Мягкий отскок от границ экрана
            if (p.x < 0) p.vx += 2;
            if (p.x > stage.stageWidth) p.vx -= 2;
            if (p.y < 0) p.vy += 2;
            if (p.y > stage.stageHeight) p.vy -= 2;
        }
    }

    private function onExplode(e:MouseEvent):Void {
        for (p in particles) {
            p.vx = (Math.random() - 0.5) * 60;
            p.vy = (Math.random() - 0.5) * 60;
        }
    }
}

/**
 * Класс частицы. 
 * Используем Shape для экономии ресурсов.
 */
class Particle extends Shape {
    public var vx:Float = 0;
    public var vy:Float = 0;

    public function new() {
        super();
        
        // Рисуем стильный треугольник
        var color = Std.int(Math.random() * 0xFFFFFF);
        graphics.beginFill(color, 0.8);
        graphics.moveTo(12, 0);
        graphics.lineTo(-6, -6);
        graphics.lineTo(-3, 0);
        graphics.lineTo(-6, 6);
        graphics.lineTo(12, 0);
        graphics.endFill();
        
        // Рандомный спавн в пределах видимости
        x = Math.random() * 800;
        y = Math.random() * 600;
    }
}