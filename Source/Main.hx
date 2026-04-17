package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Vector;

/**
 * Тестовая сцена: Интерактивный рой частиц.
 * Частицы следуют за мышью, используя простую физику притяжения.
 */
class Main extends Sprite {
    
    private var particles:Array<Particle>;
    private var numParticles:Int = 100;

    public function new() {
        super();
        
        particles = [];
        
        // Создаем частицы
        for (i in 0...numParticles) {
            var p = new Particle();
            addChild(p);
            particles.push(p);
        }
        
        // Главный цикл анимации
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        
        // Добавим клик для "взрыва"
        stage.addEventListener(MouseEvent.CLICK, onStageClick);
    }

    private function onEnterFrame(e:Event):void {
        var targetX = mouseX;
        var targetY = mouseY;

        for (p in particles) {
            // Рассчитываем ускорение в сторону мыши
            var dx = targetX - p.x;
            var dy = targetY - p.y;
            var dist = Math.sqrt(dx * dx + dy * dy);
            
            if (dist > 5) {
                p.vx += dx / 500;
                p.vy += dy / 500;
            }

            // Применяем скорость и трение
            p.vx *= 0.95;
            p.vy *= 0.95;
            p.x += p.vx;
            p.y += p.vy;
            
            // Вращение по направлению движения
            p.rotation = Math.atan2(p.vy, p.vx) * 180 / Math.PI;
        }
    }

    private function onStageClick(e:MouseEvent):void {
        // Разбрасываем частицы при клике
        for (p in particles) {
            p.vx = (Math.random() - 0.5) * 50;
            p.vy = (Math.random() - 0.5) * 50;
        }
    }
}

/**
 * Класс отдельной частицы (стрелочки)
 */
class Particle extends Shape {
    public var vx:Float = 0;
    public var vy:Float = 0;

    public function new() {
        super();
        
        // Рисуем маленькую стрелку/треугольник
        var color = Std.int(Math.random() * 0xFFFFFF);
        graphics.beginFill(color);
        graphics.moveTo(10, 0);
        graphics.lineTo(-5, -5);
        graphics.lineTo(-5, 5);
        graphics.lineTo(10, 0);
        graphics.endFill();
        
        // Случайная начальная позиция
        x = Math.random() * 800;
        y = Math.random() * 600;
        vx = (Math.random() - 0.5) * 10;
        vy = (Math.random() - 0.5) * 10;
    }
}